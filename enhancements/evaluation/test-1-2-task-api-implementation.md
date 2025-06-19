# Test 1.2: Task Management API - Implementation

## Test Setup
- **Project**: Task Management API
- **Command**: 07-construct (Feature Implementation)
- **Ticket**: "Implement CRUD endpoints for tasks"
- **Context**: User has basic requirements, chose FastAPI + PostgreSQL

## Simulated Implementation Process

### What PRIS Would Do:

1. **Pattern Search** (from Phase 4):
```
📚 Found 2 relevant patterns from library:

1. [0.95] crud-api-endpoints (python, fastapi)
   Complete CRUD implementation with pagination
   Success rate: 95%, Used 42 times

2. [0.91] input-validation (python, pydantic)
   Request validation with error handling
   Success rate: 91%, Used 31 times

Using these patterns as reference for implementation.
```

2. **Generated Code** (based on pattern):
```python
# Would generate comprehensive CRUD endpoints
# Including pagination, validation, error handling
# Probably 200+ lines of code
```

## Evaluation

### ✅ What Works Well:
1. **Pattern Library Hit**: Found relevant CRUD pattern
2. **Comprehensive Implementation**: Includes all CRUD operations
3. **Best Practices**: Validation, error handling included
4. **Test Generation**: Would create full test suite

### ❌ Problems Identified:

1. **Over-Engineering for Learning**:
   - Pattern includes pagination (not requested)
   - Complex error handling for simple learning project
   - Too many advanced features

2. **Missing Simplicity**:
   - User wanted to learn basics
   - Pattern is production-ready (overkill)
   - No graduated complexity

3. **Test Assumptions**:
   ```python
   # PRIS would generate:
   def test_list_resources_with_pagination(client, mock_db):
       """Test listing resources with pagination."""
       # User never asked for pagination!
   ```

### ⚠️ Real Example of Pattern Mismatch:

**User Wants**:
```python
@app.post("/tasks")
def create_task(task: TaskCreate):
    # Simple creation
    new_task = save_to_db(task)
    return new_task
```

**PRIS Generates** (from pattern):
```python
@router.post("/", response_model=ResourceResponse, status_code=201)
async def create_resource(
    resource: ResourceCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),  # User didn't implement auth yet!
    rate_limit: RateLimit = Depends(check_rate_limit)  # Way too advanced!
):
    """Create a new resource with full validation and rate limiting."""
    # ... 50 lines of code
```

## Specific Issues

1. **Dependency Assumptions**:
   - Assumes authentication is implemented
   - Assumes rate limiting needed
   - Assumes complex session management

2. **Naming Confusion**:
   - Pattern uses "Resource" (generic)
   - User wants "Task" (specific)
   - Requires manual renaming everywhere

3. **Import Errors Would Occur**:
   ```python
   from app.auth import get_current_user  # Doesn't exist!
   from app.ratelimit import check_rate_limit  # Doesn't exist!
   ```

## Test Generation Issues

PRIS would generate tests like:
```python
def test_create_task_unauthenticated(client):
    """Test that unauthenticated users cannot create tasks."""
    response = client.post("/api/v1/tasks", json={"title": "Test"})
    assert response.status_code == 401  # But there's no auth!
```

## Improvement Recommendations

1. **Pattern Variants**:
   ```yaml
   pattern_id: "crud-api-endpoints-simple"
   name: "Simple CRUD for Learning"
   tags: ["crud", "learning", "basic", "no-auth"]
   ```

2. **Complexity Detection**:
   - Check if auth is implemented before adding auth dependencies
   - Ask about pagination needs
   - Offer simplified version for learning

3. **Progressive Enhancement**:
   - Start with basic CRUD
   - Suggest enhancements as separate steps
   - Don't assume everything needed at once

## Score: ⚠️ Okay (2.5/5)
- Pattern library works but lacks beginner-friendly options
- Over-engineers simple requirements
- Creates dependency issues
- Tests assume features that don't exist