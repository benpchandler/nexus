---
pattern_id: "crud-api-endpoints"
name: "RESTful CRUD Endpoints"
language: "python"
framework: "fastapi"
type: "api"
tags: ["crud", "rest", "fastapi", "api", "endpoints"]
description: "Complete CRUD endpoint implementation with validation, error handling, and pagination"
usage_prompt: "When creating RESTful CRUD endpoints for a resource, use this pattern for consistent API design"
common_mistakes:
  - "Forgetting pagination on list endpoints"
  - "Missing proper error handling for 404s"
  - "Not validating request data"
  - "Exposing database IDs directly"
success_rate: 0.95
usage_count: 42
---

```python
from typing import List, Optional
from fastapi import APIRouter, HTTPException, Query, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import datetime

# Pydantic models
class ResourceBase(BaseModel):
    name: str
    description: Optional[str] = None

class ResourceCreate(ResourceBase):
    pass

class ResourceUpdate(ResourceBase):
    name: Optional[str] = None

class ResourceResponse(ResourceBase):
    id: int
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

# Router setup
router = APIRouter(prefix="/api/v1/resources", tags=["resources"])

# Dependencies
def get_db():
    # Your database session dependency
    pass

# CRUD Endpoints
@router.get("/", response_model=List[ResourceResponse])
async def list_resources(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """List resources with pagination and optional search."""
    query = db.query(Resource)
    
    if search:
        query = query.filter(Resource.name.contains(search))
    
    total = query.count()
    resources = query.offset(skip).limit(limit).all()
    
    # Add total count to response headers
    return resources

@router.get("/{resource_id}", response_model=ResourceResponse)
async def get_resource(resource_id: int, db: Session = Depends(get_db)):
    """Get a specific resource by ID."""
    resource = db.query(Resource).filter(Resource.id == resource_id).first()
    
    if not resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    
    return resource

@router.post("/", response_model=ResourceResponse, status_code=201)
async def create_resource(
    resource: ResourceCreate,
    db: Session = Depends(get_db)
):
    """Create a new resource."""
    db_resource = Resource(**resource.dict())
    db.add(db_resource)
    
    try:
        db.commit()
        db.refresh(db_resource)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Resource already exists")
    
    return db_resource

@router.put("/{resource_id}", response_model=ResourceResponse)
async def update_resource(
    resource_id: int,
    resource: ResourceUpdate,
    db: Session = Depends(get_db)
):
    """Update an existing resource."""
    db_resource = db.query(Resource).filter(Resource.id == resource_id).first()
    
    if not db_resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    
    update_data = resource.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_resource, field, value)
    
    db_resource.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_resource)
    
    return db_resource

@router.delete("/{resource_id}", status_code=204)
async def delete_resource(resource_id: int, db: Session = Depends(get_db)):
    """Delete a resource."""
    db_resource = db.query(Resource).filter(Resource.id == resource_id).first()
    
    if not db_resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    
    db.delete(db_resource)
    db.commit()
    
    return None
```

## Tests

```python
import pytest
from fastapi.testclient import TestClient
from unittest.mock import Mock

def test_list_resources_with_pagination(client: TestClient, mock_db):
    """Test listing resources with pagination."""
    # Mock data
    mock_resources = [Mock(id=i, name=f"Resource {i}") for i in range(25)]
    mock_db.query().filter().offset().limit().all.return_value = mock_resources[:20]
    mock_db.query().filter().count.return_value = 25
    
    response = client.get("/api/v1/resources?skip=0&limit=20")
    
    assert response.status_code == 200
    assert len(response.json()) == 20

def test_get_resource_not_found(client: TestClient, mock_db):
    """Test getting non-existent resource returns 404."""
    mock_db.query().filter().first.return_value = None
    
    response = client.get("/api/v1/resources/999")
    
    assert response.status_code == 404
    assert response.json()["detail"] == "Resource not found"

def test_create_resource_success(client: TestClient, mock_db):
    """Test successful resource creation."""
    resource_data = {"name": "New Resource", "description": "Test description"}
    
    response = client.post("/api/v1/resources", json=resource_data)
    
    assert response.status_code == 201
    assert response.json()["name"] == resource_data["name"]
```

## Variations

### With Authentication
Add authentication dependency:
```python
from app.auth import get_current_user

@router.post("/", dependencies=[Depends(get_current_user)])
async def create_resource(...):
    # Only authenticated users can create
```

### With Soft Delete
Replace hard delete with soft delete:
```python
@router.delete("/{resource_id}")
async def delete_resource(resource_id: int, db: Session = Depends(get_db)):
    db_resource.is_deleted = True
    db_resource.deleted_at = datetime.utcnow()
    db.commit()
```

### With Bulk Operations
Add bulk create/update endpoints:
```python
@router.post("/bulk", response_model=List[ResourceResponse])
async def bulk_create_resources(
    resources: List[ResourceCreate],
    db: Session = Depends(get_db)
):
    # Bulk insert logic
```