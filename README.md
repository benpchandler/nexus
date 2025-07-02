# NEXUS - Custom Claude Code Slash Commands

*Advanced AI-powered development workflow system for Claude Code*

## What is NEXUS?

NEXUS is a collection of custom slash commands for Claude Code that provides structured prompts and workflows for software development tasks. Each command represents a specialized prompt template designed to guide AI assistants through specific development activities with best practices and systematic approaches.

## Version

**Current Version: 1.1.0**

### Key Features
- 🚀 Structured development workflows from requirements to deployment
- 🤖 Specialized command templates for different development phases
- 📋 Living documentation system for project continuity
- 🔄 Parallel AI development support with architectural boundaries
- ⚡ Configuration system (`.nexus/config.yaml`)
- 🎯 Best practices enforcement through guided prompts

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/benpchandler/nexus.git
cd nexus
```

2. Initialize NEXUS in your project:
```bash
mkdir .nexus
```

### Project Structure

```
your-project/
├── .nexus/                    # Project-specific data
│   ├── config.yaml           # Configuration for features and behavior
│   ├── memories/             # Living documentation
│   ├── history/              # Historical snapshots
│   └── patterns/             # Reusable code pattern library
└── nexus/                    # NEXUS commands (as submodule or reference)
    ├── commands/             # Numbered command templates
    ├── docs/                 # Documentation
    └── CLAUDE.md            # AI context guide
```

### As a Git Submodule

Add NEXUS to an existing project:
```bash
git submodule add https://github.com/benpchandler/nexus.git nexus
```

## Core Commands

NEXUS provides numbered commands for each development phase:

### Setup & Discovery
- `00-initialize` - Create project structure
- `01-discover` - Interactive requirements gathering
- `02-refine` - Refine and prioritize requirements

### Development
- `03-architecture` - Design technical architecture
- `04-scaffold` - Generate code scaffolding
- `05-iterate` - Implement features iteratively
- `06-integrate` - System integration

### Quality & Deployment
- `07-test` - Comprehensive testing
- `08-document` - Generate documentation
- `09-validate` - User validation
- `10-deploy` - Deployment preparation

### Maintenance
- `11-handoff` - Create handoff documentation
- `12-review_code` - Code review
- `13-close` - Project completion

## Usage

1. Copy the desired command from `commands/XX-command-name.md`
2. Paste it into Claude Code
3. Follow the structured workflow
4. Commands validate prerequisites automatically

Example:
```bash
# Start a new project
# Copy contents of commands/00-initialize.md to Claude

# Gather requirements
# Copy contents of commands/01-discover.md to Claude
```

## Configuration

Control NEXUS behavior through `.nexus/config.yaml`:

```yaml
nexus:
  version: "1.1.0"
  features:
    pattern_library: true
    parallel_development: true
    simplicity_detection: true
  
  development:
    test_framework: "pytest"
    documentation_style: "google"
    code_style: "black"
```

## Documentation

- [CLAUDE.md](CLAUDE.md) - AI assistant context and guidelines
- [docs/](docs/) - Additional documentation
- [commands/](commands/) - All command templates

## Development Workflow

1. **Initialize**: Set up project structure
2. **Discover**: Gather and refine requirements
3. **Architect**: Design technical solution
4. **Implement**: Build features iteratively
5. **Test**: Validate functionality
6. **Deploy**: Prepare for production

## Contributing

NEXUS is designed to be extended. When adding new commands:
1. Follow the numbered naming convention
2. Include comprehensive examples
3. Update CLAUDE.md with new concepts
4. Add appropriate documentation

## License

[MIT License](LICENSE)

## Support

- Issues: [GitHub Issues](https://github.com/benpchandler/nexus/issues)
- Documentation: [Wiki](https://github.com/benpchandler/nexus/wiki)

---

*NEXUS - Making AI-assisted development systematic and reliable*