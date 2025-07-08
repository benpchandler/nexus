# Go Coding Standards (2025)

## Project Structure

### Standard Layout
```
project-root/
├── cmd/                    # Main applications
│   ├── server/
│   │   └── main.go
│   └── cli/
│       └── main.go
├── internal/               # Private packages
│   ├── app/               # Application logic
│   ├── domain/            # Business domain
│   ├── platform/          # Infrastructure
│   └── config/            # Configuration
├── pkg/                   # Public packages (reusable)
├── api/                   # API definitions
├── web/                   # Web assets
├── configs/               # Configuration files
├── scripts/               # Build/deploy scripts
├── tests/                 # Integration tests
├── testdata/              # Test fixtures
└── docs/                  # Documentation
```

### Key Principles
- **`/cmd`**: One directory per executable, minimal main.go
- **`/internal`**: Private packages, not importable externally
- **`/pkg`**: Public packages for external reuse
- **`/api`**: API schemas, protobuf, OpenAPI specs

## Naming Conventions

### Packages
- **Lowercase only**: `user`, `httputil`, `jsonrpc`
- **Single word**: Avoid underscores/mixed case
- **Descriptive**: Clear purpose from name

### Files
- **Lowercase with underscores**: `user_service.go`, `auth_handler.go`
- **Test files**: `user_service_test.go`
- **Size guideline**: ~500-1000 lines, group by functionality

### Variables & Functions
- **camelCase**: `userID`, `parseConfig()`
- **Exported**: Start with uppercase - `UserService`, `GetUser()`
- **Private**: Start with lowercase - `userCache`, `validateInput()`
- **Avoid `Get` prefix**: `User()` not `GetUser()` for getters

### Constants
- **CamelCase**: `MaxRetries`, `DefaultTimeout`
- **Grouped**: Use `const` blocks for related constants

### Structs & Interfaces
- **PascalCase**: `UserService`, `PaymentProcessor`
- **Interfaces**: Add `-er` suffix - `Reader`, `Writer`, `UserCreator`
- **One-method interfaces**: Name after method + `-er`

## Code Organization

### Function Order
1. Exported functions first
2. Group by receiver
3. Rough call order within groups

### Package Organization
- One concept per package
- Avoid circular dependencies
- Keep interfaces small and focused

## Testing Standards

### Test Files
- **Naming**: `*_test.go` suffix
- **Location**: Same package as code under test
- **Structure**: `TestFunctionName` pattern

### Test Data
- **testdata/**: For test fixtures
- **Golden files**: For expected outputs
- **Mocking**: Use interfaces for dependencies

### Benchmarks
- **Naming**: `BenchmarkFunctionName`
- **Location**: Same package or separate `*_bench_test.go`

## Linting & Formatting

### Required Tools (2025)
- **golangci-lint v2**: Primary linter
- **goimports**: Import formatting and organization
- **gofumpt**: Stricter formatting (optional)

### golangci-lint Configuration
```yaml
# .golangci.yml
run:
  timeout: 5m
  modules-download-mode: readonly

linters:
  default: fast
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - misspell
    - goimports
    - revive

linters-settings:
  goimports:
    local-prefixes: github.com/yourorg/yourproject
```

### IDE Integration
- **VS Code**: Use gopls with golangci-lint integration
- **Auto-format**: On save with goimports
- **Linting**: Real-time with golangci-lint

## Best Practices

### Error Handling
- **Explicit errors**: Always check and handle errors
- **Error wrapping**: Use `fmt.Errorf("context: %w", err)`
- **Custom errors**: Implement `Error()` method for domain errors

### Concurrency
- **Channels**: Prefer channels for communication
- **Context**: Use `context.Context` for cancellation
- **Goroutine cleanup**: Always ensure goroutines can exit

### Dependencies
- **Go modules**: Use semantic versioning
- **Minimal deps**: Avoid unnecessary dependencies
- **Vendor**: Only for reproducible builds

### Documentation
- **Package docs**: Document package purpose
- **Exported APIs**: Document all exported items
- **Examples**: Use `Example` functions for usage

## Performance Guidelines

### Memory Management
- **Avoid allocations**: In hot paths
- **Slice capacity**: Pre-allocate when size known
- **String building**: Use `strings.Builder` for concatenation

### Profiling
- **pprof**: Use for CPU and memory profiling
- **Benchmarks**: Write for critical paths
- **Load testing**: Use realistic workloads

## Security

### Input Validation
- **Sanitize**: All external inputs
- **SQL injection**: Use parameterized queries
- **Path traversal**: Validate file paths

### Dependencies
- **Security scanning**: Use `govulncheck`
- **Updates**: Keep dependencies current
- **Review**: Audit third-party packages

## Version Compatibility

### Go Version
- **Minimum**: Go 1.21+ (as of 2025)
- **Latest**: Use latest stable for new projects
- **Compatibility**: Test against supported versions

### Module Versioning
- **Semantic**: Follow semver strictly
- **Breaking changes**: Require major version bump
- **Deprecation**: Mark deprecated APIs clearly

---

*Updated for Go best practices as of June 2025*