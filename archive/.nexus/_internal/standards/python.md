# Python Standards (2025)

## Required Tools
- Docker Desktop
- VS Code with Dev Containers extension
- make

## Project Structure
```
project/
├── src/package_name/
├── tests/
├── Dockerfile
├── Dockerfile.dev
├── docker-compose.yml
├── .devcontainer/devcontainer.json
├── .dockerignore
├── pyproject.toml
├── uv.lock
├── Makefile
└── README.md
```

## Required Files

### Dockerfile
```dockerfile
# Use latest stable Python (currently 3.11+)
FROM python:slim as builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev

FROM python:slim
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH" PYTHONUNBUFFERED=1
WORKDIR /app
COPY src/ ./src/
RUN groupadd -r app && useradd -r -g app app && chown -R app:app /app
USER app
EXPOSE 8000
CMD ["python", "-m", "package_name"]
```

### Dockerfile.dev
```dockerfile
FROM python:slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen
COPY . .
CMD ["uv", "run", "python", "-m", "package_name"]
```

### docker-compose.yml
```yaml
services:
  app:
    build:
      dockerfile: Dockerfile.dev
    ports: ["8000:8000"]
    volumes: ["./src:/app/src", "./tests:/app/tests"]
    depends_on: [db, redis]
  db:
    image: postgres:15-alpine
    environment: {POSTGRES_DB: app, POSTGRES_USER: user, POSTGRES_PASSWORD: pass}
    volumes: [postgres_data:/var/lib/postgresql/data]
  redis:
    image: redis:7-alpine
volumes:
  postgres_data:
```

### Makefile
```makefile
.PHONY: dev test lint format shell stop clean install
dev: ; docker-compose up -d
test: ; docker-compose exec app uv run pytest -v --cov
lint: ; docker-compose exec app uv run ruff check src/ tests/
format: ; docker-compose exec app uv run ruff format src/ tests/
shell: ; docker-compose exec app bash
stop: ; docker-compose down
clean: ; docker-compose down -v && docker system prune -f
install: ; docker-compose build && docker-compose run --rm app uv sync
```

### pyproject.toml
```toml
[project]
name = "package-name"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = ["pytest", "pytest-cov", "ruff", "mypy"]

[tool.ruff]
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = ["--cov=src", "--cov-report=term-missing"]

[tool.mypy]
disallow_untyped_defs = true
```

## Commands
```bash
# Setup
make install
make dev

# Development
make test
make lint  
make format
make shell

# Cleanup
make stop
```

## Naming Conventions
- **Packages**: `snake_case`
- **Files**: `snake_case.py`
- **Classes**: `PascalCase`
- **Functions/Variables**: `snake_case`
- **Constants**: `UPPER_SNAKE_CASE`

## Type Hints
Use type hints on all functions. Use modern syntax: `list[str]` not `List[str]`.

---

*All development in Docker containers. No local Python installations.*