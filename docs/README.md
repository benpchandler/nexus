# NEXUS Documentation

Welcome to the NEXUS (Polymorphic Reality Implementation System) documentation. This directory contains all supporting documentation for understanding, using, and extending NEXUS.

## Documentation Structure

### 📁 [_templates/](/_templates/)
Document templates for consistent project documentation:
- **ADR Templates**: Architecture Decision Records (full and micro versions)
- **CLAUDE Templates**: AI context documentation templates
- **Project Templates**: PRD, TDD, Vision documents
- **Quick Decision Template**: For rapid decision documentation

### 📁 [architecture/](/architecture/)
Architecture documentation and decisions:
- Architecture Decision Records (ADRs)
- System design documentation
- Pattern library and best practices

### 📁 [development/](/development/)
Development guidelines and workflows:
- Developer documentation best practices
- NEXUS documentation workflow
- Contribution guidelines
- Development setup instructions

### 📁 [project-status/](/project-status/)
Project tracking and status:
- EXTRACTION-STATUS: Current implementation status
- Version history and milestones
- Roadmap and future features

### 📁 [guides/](/guides/)
User and developer guides:
- Quick start guides
- Common scenarios and solutions
- Tips and troubleshooting
- Advanced usage patterns

### 📄 [command-mapping.md](/command-mapping.md)
Maps human-friendly descriptions to NEXUS command numbers.

### 📄 [project-structure-example.md](/project-structure-example.md)
Example of how to organize documentation in a NEXUS project.

## Quick Links

### For New Users
1. Start with the [Quick Start Guide](/guides/README.md)
2. Review the [Command Index](/commands/README.md)
3. Understand the [Architecture](/architecture/README.md)

### For Developers
1. Read [Development Guidelines](/development/developer-documentation-best-practices.md)
2. Check [Documentation Workflow](/development/NEXUS-DOCUMENTATION-WORKFLOW.md)
3. Use appropriate [Templates](/_templates/README.md)

### For Contributors
1. Review [Project Status](/project-status/EXTRACTION-STATUS.md)
2. Understand the [Command Structure](/commands/ARCHITECTURE_VS_SETUP.md)
3. Follow [Best Practices](/development/README.md)

## Key Concepts

### Commands
NEXUS operates through numbered commands (00-13) that represent specialized AI agents. Each command handles a specific phase of the development lifecycle.

### Memory System
- **Living Documents**: Continuously updated files in `.nexus/memories/`
- **History**: Historical snapshots in `.nexus/history/`
- **NEXUS.json**: Central configuration

### Parallel Development
Multiple AI agents can work simultaneously using:
- Architectural boundaries to prevent conflicts
- Work contracts for clean separation
- AGENT_NOTES.md for communication

## Documentation Standards

1. **Clarity**: Write for your audience (users, developers, or contributors)
2. **Examples**: Include practical, working examples
3. **Organization**: Use consistent structure and navigation
4. **Maintenance**: Keep documentation up-to-date with code changes
5. **Accessibility**: Use clear headings and formatting

## Getting Help

- **Commands**: See `/commands/README.md` for the command index
- **Templates**: Use `/docs/_templates/` for consistent documentation
- **Context**: Check `/CLAUDE.md` for AI assistant context
- **Issues**: Report problems via GitHub Issues with appropriate labels

---

*This documentation is part of NEXUS v1.0.0*