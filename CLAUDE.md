# NEXUS AI Context and Guidelines

*This document provides context for AI assistants working with the NEXUS project - Custom Claude Code Slash Commands.*

## Project Overview

NEXUS is a collection of custom slash commands for Claude Code that provides structured prompts and workflows for software development tasks. Each command represents a specialized prompt template designed to guide AI assistants through specific development activities with best practices and systematic approaches.

## Key Concepts

### 1. Command-Based Architecture
- NEXUS operates through numbered commands (00-13)
- Each command represents a specialized AI agent with specific expertise
- Commands build on each other in a structured workflow
- Commands are stored in `/commands/` directory with numbered prefixes

### 2. Memory System
- **Living Documents**: Continuously updated files in `.nexus/memories/`
- **History**: Historical snapshots of work in `.nexus/history/`
- **NEXUS.json**: Central configuration and state management
- **AGENT_NOTES.md**: Distributed communication files for parallel AI coordination

### 3. Parallel AI Development
- Multiple AI agents can work simultaneously
- Architectural boundaries prevent merge conflicts
- Work contracts ensure clean separation of concerns
- GitHub issues track agent assignments

## Working with NEXUS Commands

### Command Naming Convention
- Format: `XX-name.md` where XX is a two-digit number
- Examples: `00-initialize.md`, `01-discover.md`
- Numbers indicate workflow order and dependencies

### Command Types
1. **Setup**: Initialize system (00)
2. **Interactive**: Require human input (01, 02)
3. **Autonomous**: Work independently (03-13)
4. **Utility**: System maintenance and helpers

### Using Commands
- Each command is a complete prompt template
- Copy the entire command content to Claude
- Commands include role definitions, thinking structures, and examples
- Commands check their prerequisites automatically

## File Structure

```
nexus/
├── README.md                  # Main project documentation
├── CLAUDE.md                  # This file - AI context
├── commands/                  # All NEXUS command prompts
│   ├── 00-initialize.md      # System initialization
│   ├── 01-discover.md        # Requirements gathering
│   └── ...                   # Other commands
├── docs/                     # Additional documentation
│   ├── _templates/           # Document templates
│   ├── architecture/         # Architecture decisions
│   ├── development/          # Development guidelines
│   └── guides/              # User guides
└── .nexus/                   # Runtime data (created by NEXUS)
    ├── NEXUS.json           # Configuration
    ├── memories/            # Living documents
    └── history/            # Historical records
```

## Best Practices for AI Assistants

### 1. Command Execution
- Always read the full command prompt before executing
- Check prerequisites mentioned in the command
- Follow the structured thinking process (`<analysis>`, `<validation>` tags)
- Use the examples provided in each command as reference

### 2. File Management
- Living documents in `memories/` should be updated, not replaced
- Historical records in `history/` should never be modified
- Use consistent naming conventions for generated files
- Always check for existing files before creating new ones

### 3. Communication
- Update AGENT_NOTES.md when making significant changes
- Document architectural decisions and rationale
- Provide clear commit messages and PR descriptions
- Include uncertainty tags when unsure about decisions

### 4. Quality Standards
- All code should include tests
- Follow the technology choices made in architecture phase
- Validate inputs and handle errors gracefully
- Generate comprehensive documentation

## Common Tasks

### Initialize a New Project
```bash
# Use 00-initialize.md to create .nexus structure
```

### Implement a Feature
```bash
# Use 04-scaffold.md with a ticket ID from the backlog
```

### Review Code
```bash
# Use 12-review_code.md with a branch name
```

### Generate Documentation
```bash
# Use 11-create_handoff.md to create project documentation
```

## Troubleshooting

### Missing Prerequisites
- Each command validates its required inputs
- Check `.nexus/memories/` for current state
- Review inception.log for operation history

### Conflicting Changes
- Check AGENT_NOTES.md files before starting work
- Use orchestration commands for parallel development
- Respect architectural boundaries defined in contracts

### Version Issues
- Use 92-migrate.md for migrations
- Check NEXUS.json for current version
- Review migration guides in history/

## Future Development

When extending NEXUS:
1. Follow the numbered command convention
2. Include comprehensive examples in new commands
3. Update this CLAUDE.md with new concepts
4. Add appropriate templates to docs/_templates/
5. Maintain backward compatibility

---

*Last Updated: 2025-07-02*
*This document should be updated when new commands or concepts are added to NEXUS.*