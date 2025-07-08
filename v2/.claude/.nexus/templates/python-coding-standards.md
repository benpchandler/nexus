# Python Coding Standards & TDD Patterns

## Project Structure
```
src/
├── api/            # HTTP request handling
├── services/       # Business logic
├── repositories/   # Data access
├── models/         # Data models
├── utils/          # Shared utilities
└── tests/          # Test files
```

## Testing Patterns
- `pytest` for test discovery and fixtures
- `unittest.mock` for mocking dependencies
- Type hints for better documentation and IDE support
- Parametrized tests for comprehensive coverage

## TDD Patterns
- Dataclasses/Pydantic for data models
- Constructor-based dependency injection
- Exception handling with custom error types
- pytest fixtures for test setup and teardown

## Code Quality
- `black` for code formatting
- `flake8` or `ruff` for linting
- `mypy` for type checking
- `pytest-cov` for coverage reporting

*This file will contain comprehensive Python-specific TDD patterns and best practices.*