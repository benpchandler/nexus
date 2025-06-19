---
pattern_id: "integration-test-api"
name: "API Integration Test Pattern"
language: "python"
framework: "pytest"
type: "testing"
tags: ["testing", "integration", "api", "pytest", "fixtures"]
description: "Comprehensive integration test setup with database transactions, fixtures, and API client"
usage_prompt: "When writing integration tests for APIs, use this pattern for proper test isolation and realistic testing"
common_mistakes:
  - "Not rolling back database changes between tests"
  - "Using production database for tests"
  - "Not mocking external services"
  - "Tests depending on execution order"
success_rate: 0.89
usage_count: 31
---

```python
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
import os
from typing import Generator
from unittest.mock import patch, Mock

# Import your app and models
from app.main import app
from app.database import Base, get_db
from app.models import User, Resource
from app.auth import create_access_token

# Test database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Fixtures
@pytest.fixture(scope="function")
def db_session():
    """Create a fresh database for each test."""
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db_session) -> Generator:
    """Create a test client with database override."""
    def override_get_db():
        try:
            yield db_session
        finally:
            pass
    
    app.dependency_overrides[get_db] = override_get_db
    
    with TestClient(app) as test_client:
        yield test_client
    
    app.dependency_overrides.clear()

@pytest.fixture
def test_user(db_session) -> User:
    """Create a test user."""
    user = User(
        email="test@example.com",
        username="testuser",
        hashed_password="hashed_password_here",
        is_active=True
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user

@pytest.fixture
def auth_headers(test_user) -> dict:
    """Generate authentication headers for test user."""
    token = create_access_token(data={"sub": test_user.email})
    return {"Authorization": f"Bearer {token}"}

@pytest.fixture
def mock_external_service():
    """Mock external API calls."""
    with patch('app.services.external_api.ExternalClient') as mock:
        mock_instance = Mock()
        mock_instance.fetch_data.return_value = {
            "status": "success",
            "data": {"example": "data"}
        }
        mock.return_value = mock_instance
        yield mock_instance

# Test Classes
class TestResourceAPI:
    """Test suite for Resource endpoints."""
    
    def test_create_resource_authenticated(
        self, client: TestClient, auth_headers: dict, db_session
    ):
        """Test creating a resource as authenticated user."""
        resource_data = {
            "name": "Test Resource",
            "description": "Test Description",
            "metadata": {"key": "value"}
        }
        
        response = client.post(
            "/api/v1/resources",
            json=resource_data,
            headers=auth_headers
        )
        
        assert response.status_code == 201
        data = response.json()
        assert data["name"] == resource_data["name"]
        assert "id" in data
        
        # Verify in database
        db_resource = db_session.query(Resource).filter(
            Resource.id == data["id"]
        ).first()
        assert db_resource is not None
        assert db_resource.name == resource_data["name"]
    
    def test_create_resource_unauthenticated(self, client: TestClient):
        """Test that unauthenticated users cannot create resources."""
        response = client.post(
            "/api/v1/resources",
            json={"name": "Test"}
        )
        
        assert response.status_code == 401
        assert "detail" in response.json()
    
    def test_list_resources_with_pagination(
        self, client: TestClient, db_session, test_user
    ):
        """Test listing resources with pagination."""
        # Create test data
        for i in range(25):
            resource = Resource(
                name=f"Resource {i}",
                owner_id=test_user.id
            )
            db_session.add(resource)
        db_session.commit()
        
        # Test first page
        response = client.get("/api/v1/resources?skip=0&limit=10")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 10
        assert data[0]["name"] == "Resource 0"
        
        # Test second page
        response = client.get("/api/v1/resources?skip=10&limit=10")
        assert response.status_code == 200
        data = response.json()
        assert len(data) == 10
        assert data[0]["name"] == "Resource 10"
    
    def test_update_resource_owner_only(
        self, client: TestClient, db_session, test_user, auth_headers
    ):
        """Test that only resource owner can update."""
        # Create resource
        resource = Resource(name="Original", owner_id=test_user.id)
        db_session.add(resource)
        db_session.commit()
        
        # Update as owner
        response = client.put(
            f"/api/v1/resources/{resource.id}",
            json={"name": "Updated"},
            headers=auth_headers
        )
        
        assert response.status_code == 200
        assert response.json()["name"] == "Updated"
        
        # Create another user
        other_user = User(email="other@example.com", username="other")
        db_session.add(other_user)
        db_session.commit()
        
        # Try to update as different user
        other_token = create_access_token(data={"sub": other_user.email})
        other_headers = {"Authorization": f"Bearer {other_token}"}
        
        response = client.put(
            f"/api/v1/resources/{resource.id}",
            json={"name": "Hacked"},
            headers=other_headers
        )
        
        assert response.status_code == 403

class TestExternalIntegration:
    """Test external service integration."""
    
    def test_fetch_with_external_data(
        self, client: TestClient, mock_external_service, auth_headers
    ):
        """Test endpoint that uses external service."""
        response = client.get(
            "/api/v1/resources/1/external-data",
            headers=auth_headers
        )
        
        assert response.status_code == 200
        assert mock_external_service.fetch_data.called
        assert response.json()["external_data"]["example"] == "data"
    
    def test_external_service_failure(
        self, client: TestClient, mock_external_service, auth_headers
    ):
        """Test handling of external service failures."""
        mock_external_service.fetch_data.side_effect = Exception("Service down")
        
        response = client.get(
            "/api/v1/resources/1/external-data",
            headers=auth_headers
        )
        
        assert response.status_code == 503
        assert "Service temporarily unavailable" in response.json()["detail"]

# Parametrized Tests
@pytest.mark.parametrize("invalid_data,expected_error", [
    ({"name": ""}, "Name cannot be empty"),
    ({"name": "a" * 256}, "Name too long"),
    ({"name": "Test", "metadata": "invalid"}, "Metadata must be object"),
])
def test_create_resource_validation(
    client: TestClient, auth_headers: dict, invalid_data: dict, expected_error: str
):
    """Test various validation scenarios."""
    response = client.post(
        "/api/v1/resources",
        json=invalid_data,
        headers=auth_headers
    )
    
    assert response.status_code == 422
    assert expected_error in str(response.json())

# Test Utilities
def create_test_resources(db_session, user: User, count: int = 5) -> list:
    """Helper to create multiple test resources."""
    resources = []
    for i in range(count):
        resource = Resource(
            name=f"Test Resource {i}",
            owner_id=user.id
        )
        db_session.add(resource)
        resources.append(resource)
    db_session.commit()
    return resources
```

## Configuration

```python
# conftest.py - Shared pytest configuration
import pytest
from typing import Generator
import asyncio

# Configure async tests
@pytest.fixture(scope="session")
def event_loop() -> Generator:
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

# Test settings
@pytest.fixture(autouse=True)
def test_settings(monkeypatch):
    """Override settings for tests."""
    monkeypatch.setenv("ENVIRONMENT", "test")
    monkeypatch.setenv("DATABASE_URL", "sqlite:///:memory:")
    monkeypatch.setenv("SECRET_KEY", "test-secret-key")
    monkeypatch.setenv("EXTERNAL_API_KEY", "test-api-key")
```

## Variations

### Async Tests
```python
@pytest.mark.asyncio
async def test_async_endpoint(client: TestClient, auth_headers: dict):
    """Test async endpoint."""
    response = await client.get("/api/v1/async-endpoint", headers=auth_headers)
    assert response.status_code == 200
```

### WebSocket Tests
```python
def test_websocket_connection(client: TestClient, auth_headers: dict):
    """Test WebSocket endpoint."""
    with client.websocket_connect(
        "/ws/updates",
        headers=auth_headers
    ) as websocket:
        websocket.send_json({"type": "subscribe", "channel": "updates"})
        data = websocket.receive_json()
        assert data["type"] == "subscribed"
```

### Performance Tests
```python
@pytest.mark.performance
def test_bulk_create_performance(client: TestClient, auth_headers: dict):
    """Test bulk creation performance."""
    import time
    
    resources = [{"name": f"Resource {i}"} for i in range(100)]
    
    start = time.time()
    response = client.post(
        "/api/v1/resources/bulk",
        json=resources,
        headers=auth_headers
    )
    duration = time.time() - start
    
    assert response.status_code == 201
    assert duration < 2.0  # Should complete within 2 seconds
```