---
pattern_id: "jwt-authentication"
name: "JWT Authentication with Refresh Tokens"
language: "python"
framework: "fastapi"
type: "api"
tags: ["authentication", "jwt", "security", "oauth", "refresh-token"]
description: "Secure JWT authentication implementation with refresh token rotation"
usage_prompt: "When implementing user authentication with JWT tokens, use this pattern for security best practices"
common_mistakes:
  - "Storing sensitive data in JWT payload"
  - "Not implementing refresh token rotation"
  - "Missing CSRF protection"
  - "Weak secret keys"
success_rate: 0.94
usage_count: 67
---

```python
from datetime import datetime, timedelta, timezone
from typing import Optional, Dict, Any
from fastapi import APIRouter, HTTPException, Depends, status, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel, EmailStr
import secrets
import os

# Configuration
SECRET_KEY = os.getenv("JWT_SECRET_KEY", secrets.token_urlsafe(32))
REFRESH_SECRET_KEY = os.getenv("JWT_REFRESH_SECRET_KEY", secrets.token_urlsafe(32))
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 15
REFRESH_TOKEN_EXPIRE_DAYS = 30

# Setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()
router = APIRouter(prefix="/api/v1/auth", tags=["authentication"])

# Models
class UserLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int

class RefreshRequest(BaseModel):
    refresh_token: str

# Utility Functions
def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash."""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    """Generate password hash."""
    return pwd_context.hash(password)

def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    """Create JWT access token."""
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + (expires_delta or timedelta(minutes=15))
    
    to_encode.update({
        "exp": expire,
        "iat": datetime.now(timezone.utc),
        "type": "access"
    })
    
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def create_refresh_token(data: Dict[str, Any]) -> str:
    """Create JWT refresh token with longer expiration."""
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    
    to_encode.update({
        "exp": expire,
        "iat": datetime.now(timezone.utc),
        "type": "refresh",
        "jti": secrets.token_urlsafe(32)  # Unique token ID for rotation
    })
    
    return jwt.encode(to_encode, REFRESH_SECRET_KEY, algorithm=ALGORITHM)

def decode_token(token: str, token_type: str = "access") -> Dict[str, Any]:
    """Decode and validate JWT token."""
    try:
        secret = SECRET_KEY if token_type == "access" else REFRESH_SECRET_KEY
        payload = jwt.decode(token, secret, algorithms=[ALGORITHM])
        
        if payload.get("type") != token_type:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type"
            )
        
        return payload
        
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )

# Dependencies
async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Security(security),
    db: Session = Depends(get_db)
) -> User:
    """Extract and validate current user from JWT token."""
    token = credentials.credentials
    payload = decode_token(token, "access")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials"
        )
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Inactive user"
        )
    
    return user

# Endpoints
@router.post("/login", response_model=TokenResponse)
async def login(
    user_credentials: UserLogin,
    db: Session = Depends(get_db)
) -> TokenResponse:
    """Authenticate user and return tokens."""
    # Find user
    user = db.query(User).filter(User.email == user_credentials.email).first()
    
    if not user or not verify_password(user_credentials.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Account is disabled"
        )
    
    # Create tokens
    access_token = create_access_token(data={"sub": str(user.id)})
    refresh_token = create_refresh_token(data={"sub": str(user.id)})
    
    # Store refresh token in database (for rotation/revocation)
    token_record = RefreshToken(
        user_id=user.id,
        token=refresh_token,
        expires_at=datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    )
    db.add(token_record)
    db.commit()
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=ACCESS_TOKEN_EXPIRE_MINUTES * 60
    )

@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(
    refresh_request: RefreshRequest,
    db: Session = Depends(get_db)
) -> TokenResponse:
    """Generate new access token using refresh token."""
    # Decode refresh token
    payload = decode_token(refresh_request.refresh_token, "refresh")
    user_id = payload.get("sub")
    
    # Verify refresh token exists in database
    stored_token = db.query(RefreshToken).filter(
        RefreshToken.token == refresh_request.refresh_token,
        RefreshToken.user_id == user_id,
        RefreshToken.is_revoked == False,
        RefreshToken.expires_at > datetime.now(timezone.utc)
    ).first()
    
    if not stored_token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token"
        )
    
    # Rotate refresh token (invalidate old, create new)
    stored_token.is_revoked = True
    
    # Create new tokens
    new_access_token = create_access_token(data={"sub": user_id})
    new_refresh_token = create_refresh_token(data={"sub": user_id})
    
    # Store new refresh token
    new_token_record = RefreshToken(
        user_id=user_id,
        token=new_refresh_token,
        expires_at=datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    )
    db.add(new_token_record)
    db.commit()
    
    return TokenResponse(
        access_token=new_access_token,
        refresh_token=new_refresh_token,
        expires_in=ACCESS_TOKEN_EXPIRE_MINUTES * 60
    )

@router.post("/logout")
async def logout(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, str]:
    """Logout user and revoke all refresh tokens."""
    # Revoke all user's refresh tokens
    db.query(RefreshToken).filter(
        RefreshToken.user_id == current_user.id,
        RefreshToken.is_revoked == False
    ).update({"is_revoked": True})
    
    db.commit()
    
    return {"message": "Successfully logged out"}

@router.get("/me")
async def get_me(current_user: User = Depends(get_current_user)) -> Dict[str, Any]:
    """Get current user information."""
    return {
        "id": current_user.id,
        "email": current_user.email,
        "name": current_user.name,
        "is_active": current_user.is_active
    }
```

## Database Models

```python
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class RefreshToken(Base):
    __tablename__ = "refresh_tokens"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    token = Column(String, unique=True, index=True, nullable=False)
    is_revoked = Column(Boolean, default=False)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
```

## Tests

```python
import pytest
from fastapi.testclient import TestClient
from datetime import datetime, timedelta, timezone

def test_login_success(client: TestClient, test_user):
    """Test successful login."""
    response = client.post("/api/v1/auth/login", json={
        "email": test_user.email,
        "password": "testpassword123"
    })
    
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["token_type"] == "bearer"

def test_login_invalid_credentials(client: TestClient):
    """Test login with invalid credentials."""
    response = client.post("/api/v1/auth/login", json={
        "email": "wrong@example.com",
        "password": "wrongpassword"
    })
    
    assert response.status_code == 401
    assert "Incorrect email or password" in response.json()["detail"]

def test_refresh_token(client: TestClient, auth_tokens):
    """Test refresh token functionality."""
    response = client.post("/api/v1/auth/refresh", json={
        "refresh_token": auth_tokens["refresh_token"]
    })
    
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["access_token"] != auth_tokens["access_token"]

def test_protected_endpoint(client: TestClient, auth_tokens):
    """Test accessing protected endpoint."""
    response = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {auth_tokens['access_token']}"}
    )
    
    assert response.status_code == 200
    assert "email" in response.json()
```

## Security Considerations

1. **Environment Variables**: Always use strong, unique secrets from environment variables
2. **Token Rotation**: Implement refresh token rotation to prevent replay attacks
3. **Rate Limiting**: Add rate limiting to authentication endpoints
4. **Secure Transport**: Always use HTTPS in production
5. **Token Storage**: Store tokens securely on client (httpOnly cookies preferred)
6. **Monitoring**: Log authentication attempts and failures