# PRIS User Guides

This directory contains practical guides for using PRIS effectively.

## Quick Start Guides

### 1. First Project with PRIS
```bash
# Initialize PRIS
/PRIS 00-baseline

# Gather requirements interactively
/PRIS 01-voight-kampff

# Create prioritized backlog
/PRIS 02-joshi

# Select architecture
/PRIS 07-construct

# Generate setup
/PRIS 03-tyrell

# Run setup
./setup.sh my-project
```

### 2. Implementing Features
```bash
# Check backlog in .pris/memories/_20-BACKLOG.md
# Find a ticket ID (e.g., FEAT-001)

# Implement the feature
/PRIS 04-sebastian FEAT-001

# Review the implementation
/PRIS 05-wallace feat/FEAT-001
```

### 3. Parallel Development
```bash
# One-time setup
/PRIS 030-orchestrate setup

# Break down epic
/PRIS 035-decompose EPIC-001

# Each agent in separate terminal:
/PRIS 040-sync --claim
/PRIS 04-sebastian <issue-number>
/PRIS 045-coordinate --complete
```

## Guide Topics

### For Beginners
- **Getting Started**: Complete walkthrough of first project
- **Understanding Commands**: What each command does
- **Reading PRIS Output**: Interpreting results and reports

### For Developers
- **[Architecture vs Setup](architecture-vs-setup.md)**: Understanding the separation between design and implementation
- **Custom Commands**: Adding new PRIS commands
- **Integration Guide**: Connecting PRIS with existing projects
- **Advanced Workflows**: Complex development patterns

### For Teams
- **Parallel Development**: Running multiple AI agents
- **Collaboration**: Sharing PRIS state across team
- **Best Practices**: Proven patterns for team success

## Common Scenarios

### Scenario 1: Building a Web Application
1. Requirements focus on user stories and UI/UX
2. Architecture selects modern web stack
3. Implementation follows component-based approach
4. Testing includes unit and integration tests

### Scenario 2: Building an API Service
1. Requirements focus on endpoints and data models
2. Architecture selects appropriate backend framework
3. Implementation includes OpenAPI documentation
4. Testing emphasizes contract testing

### Scenario 3: Migrating Legacy System
1. Requirements include compatibility constraints
2. Architecture plans incremental migration
3. Implementation uses adapter patterns
4. Testing ensures backward compatibility

## Tips and Tricks

1. **Use Living Documents**: Always check `.pris/memories/` for latest state
2. **Trust the Process**: Let each command complete its analysis
3. **Provide Context**: More detailed requirements = better results
4. **Review Everything**: AI generates code, humans ensure quality
5. **Iterate Quickly**: Use PRIS for rapid prototyping

## Troubleshooting

### Common Issues

**"Prerequisites not met"**
- Check that previous commands have been run
- Verify files exist in `.pris/memories/`

**"Cannot find ticket"**
- Ensure ticket ID exists in backlog
- Check ticket hasn't been completed

**"Architecture mismatch"**
- Verify architecture decision in memories
- Ensure setup script was run successfully

### Getting Help

1. Check command examples in `/commands/`
2. Review this guide for common scenarios
3. Check CLAUDE.md for AI context
4. Submit issues on GitHub with PRIS labels