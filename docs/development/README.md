# Development Documentation

This directory contains development guidelines, workflows, and best practices for working with NEXUS.

## Contents

- **developer-documentation-best-practices.md**: Guidelines for writing effective documentation
- **NEXUS-DOCUMENTATION-WORKFLOW.md**: Workflow for maintaining NEXUS documentation
- **Development Guides**: How-to guides for common development tasks

## Key Development Concepts

### 1. Command Development
- Follow the numbered command convention (XX-name.md)
- Include comprehensive examples and error handling
- Use structured thinking tags (`<analysis>`, `<validation>`)
- Test commands thoroughly before adding to the system

### 2. Memory Management
- Living documents are continuously updated
- Historical archives preserve point-in-time snapshots
- NEXUS.json maintains system state
- AGENT_NOTES.md enables async communication

### 3. Parallel Development
- Multiple AI agents can work simultaneously
- Architectural boundaries prevent conflicts
- Work contracts define clear interfaces
- GitHub integration tracks progress

## Contributing to NEXUS

1. **Adding New Commands**:
   - Choose the next available number
   - Follow existing command structure
   - Include role definition and examples
   - Update command index in /commands/README.md

2. **Improving Documentation**:
   - Keep documentation close to code
   - Use templates from docs/_templates/
   - Include practical examples
   - Maintain the CLAUDE.md context file

3. **Testing Changes**:
   - Test commands in isolation
   - Verify workflow integration
   - Check for prerequisite handling
   - Validate output formats

## Development Tools

- **Version Control**: Git
- **Issue Tracking**: GitHub Issues with NEXUS labels
- **Documentation**: Markdown with Mermaid diagrams
- **Testing**: Command validation through execution

## Quick Reference

| Task | Command | Notes |
|------|---------|-------|
| Initialize NEXUS | 00-baseline | Creates .nexus structure |
| Gather Requirements | 01-voight-kampff | Interactive process |
| Select Architecture | 07-construct | Based on requirements |
| Implement Feature | 04-sebastian | Requires ticket ID |
| Review Code | 05-wallace | Requires branch name |
| Validate Requirements | 11-vk | Quality check |