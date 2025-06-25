```
 ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
 ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
 ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
 ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
 ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
 ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
                                              
 ╔═══════════════════════════════════════════════════════════════╗
 ║  V O I G H T - K A M P F F   T E S T   A C T I V E            ║
 ╚═══════════════════════════════════════════════════════════════╝
                                                                  
                    ╱▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔╲                     
                  ╱ ,''''''''''........... ╲                     
                ╱ ,'''''....::@@@@@@::..... ╲       
               │ ,''....::@@@@@@@@@@@@@@::... │       
               │ ,'..::@@@@@@@@@@@@@@@@@@@@:. │       
               │ ..::@@@@@@#######@@@@@@@@@@: │       
               │ .:@@@@@###  ●●●  ###@@@@@@@: │       
               │ :@@@@@@###       ###@@@@@@@@: │                 
               │ :@@@@@@###  ▄▄▄  ###@@@@@@@@: │                 
               │ ':@@@@@#############@@@@@@@:' │                 
                ╲ '..::@@@@@@@@@@@@@@@@@::...' ╱                 
                  ╲ ....'':::@@@@@@::''.... ╱     
                    ╲▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁╱                     
                                                                  
 ╔═══════════════════════════════════════════════════════════════╗
 ║  AI Development Orchestration & Implementation Platform      ║
 ║                                                               ║
 ║  "When machines think together, even the impossible          ║
 ║   becomes routine."                                           ║
 ║                                                               ║
 ║  [■■■■■■■■■■] NEXUS ACTIVE: OPERATIONAL                      ║
 ║  [AGENTS SYNCHRONIZED: CONFIRMED]                            ║
 ║  [ARCHITECTURE COHERENT: VERIFIED]                           ║
 ╚═══════════════════════════════════════════════════════════════╝
```

# NEXUS - AI Development Orchestration Platform

*"When machines think together, even the impossible becomes routine."*

## What is NEXUS?

NEXUS is an advanced AI-powered development workflow system that manages the complete software development lifecycle from requirements gathering to deployment. It functions as a team of specialized AI agents, each expert in their domain, working together to deliver production-ready software through systematic, best-practice approaches.

## Version

**Current Version: 1.1.0**

This release introduces intelligent simplicity detection and enhanced capabilities:
- **NEW**: Simplicity Detection System - NEXUS adapts to project complexity
- **NEW**: Pattern Library with reusable code patterns
- **NEW**: Parallel AI Agent Orchestration for simultaneous development
- **NEW**: Configuration system (`.pris/config.yaml`)
- **NEW**: Professional command naming (no forced character references)
- Complete rebranding from PRIS to NEXUS
- Global Claude Code command support
- Modern cyberpunk aesthetic
- Full development lifecycle coverage

## Installation

### For Claude Code Users (Recommended)

NEXUS integrates seamlessly with Claude Code through custom slash commands. This approach keeps commands centralized and up-to-date while maintaining project-specific data.

```bash
# 1. Clone NEXUS to a central location (if not already done)
cd ~/Dev
git clone https://github.com/benpchandler/nexus.git

# 2. In your project, create symlink for Claude Code commands
cd your-project
mkdir -p .claude/commands
# Use absolute path for the symlink
ln -s /full/path/to/nexus/commands .claude/commands/NEXUS
# Example: ln -s /Users/username/Dev/nexus/commands .claude/commands/NEXUS

# 3. Initialize project-specific NEXUS workspace
mkdir .pris
# Run initialization (through Claude Code: /NEXUS/00-initialize)
```

This gives you:
- `.claude/commands/NEXUS/` → Shared NEXUS commands (always up-to-date)
- `.pris/` → Project-specific data (memories, cells, logs)
- `.pris/config.yaml` → Configuration for features and behavior
- `.pris/patterns/` → Reusable code pattern library

**Troubleshooting**: To verify your symlink is working:
```bash
# Should list all NEXUS command files
ls -la .claude/commands/NEXUS/
```

### As a Git Submodule (For Non-Claude Code Users)

```bash
# Add NEXUS to your project
git submodule add https://github.com/benpchandler/nexus.git .pris
git commit -m "Add NEXUS as submodule"

# Initialize NEXUS
nexus 00-initialize
```

### For Fresh Clones with Submodules

```bash
git clone --recurse-submodules https://github.com/your-username/your-project.git
```

## Command Reference

### Core Development Flow

| Command | Name | Purpose | Type |
|---------|------|---------|------|
| 00 | initialize | Initialize NEXUS tracking system | Setup |
| 01 | discover | Gather comprehensive system requirements | Interactive |
| 02 | prioritize | Create prioritized product backlog | Interactive |
| 03 | architect | Generate project setup script | Autonomous |
| 04 | scaffold | Implement features with tests | Autonomous |
| 05 | construct | Feature implementation with TDD | Autonomous |
| 06 | verify | Test and validate implementations | Autonomous |
| 07 | refine | Code review and quality analysis | Autonomous |

### Parallel AI Development (NEW!)

| Command | Name | Purpose | Type |
|---------|------|---------|------|
| 08 | setup_orchestration | Setup parallel AI coordination | Autonomous |
| 09 | decompose_epic | Break epics into work contracts | Autonomous |
| 10 | claim_work | Claim and execute work contracts | Autonomous |
| 11 | create_handoff | Documentation generation | Autonomous |
| 12 | review_code | Multi-modal review (code, docs, PRs) | Autonomous |

### Utility Commands

| Command | Name | Purpose | Type |
|---------|------|---------|------|
| 90 | validate | Requirements validation | Utility |
| 91 | optimize | Performance optimization | Utility |
| 92 | migrate | Version migration | Utility |
| 93 | spawn_parallel | Direct parallel agent spawning | Utility |
| 98 | patterns | Pattern library management | Utility |

## Directory Structure

```
.pris/
├── NEXUS.json          # System configuration
├── config.yaml         # Feature flags and settings
├── operations.log     # Operation log
├── memories/           # Living documents
│   ├── _10-REQUIREMENTS.md    # Requirements
│   ├── _20-BACKLOG.md         # Prioritized features
│   ├── _30-ARCHITECTURE.md    # Architecture
│   └── _40-ISSUES.md          # Issues/tests
├── history/           # Historical artifacts
│   ├── 10-discovery-results/  # Requirements artifacts
│   ├── 20-assignments/        # Planning records
│   ├── 30-blueprints/         # Architecture records
│   ├── 40-construction/       # Implementation records
│   └── 50-investigations/     # Review history
├── orchestration/     # Parallel AI coordination (NEW!)
│   ├── agents/        # Agent management
│   ├── contracts/     # Work contracts
│   └── boundaries.json # Architectural boundaries
└── patterns/          # Reusable code patterns
    ├── api/           # API patterns
    ├── frontend/      # Frontend patterns
    ├── testing/       # Test patterns
    └── security/      # Security patterns
```

## Key Features

### Parallel AI Agent Development (NEW!)

NEXUS now supports orchestrated parallel development with multiple AI agents working simultaneously:
- **Multiple Agents**: Run 2-4 Claude Code instances simultaneously
- **No Merge Conflicts**: Architectural boundaries prevent overlapping changes
- **Smart Coordination**: AGENT_NOTES.md files for async communication
- **GitHub Integration**: Work contracts tracked as GitHub issues
- **Dependency Management**: Automatic blocking/unblocking of dependent work

### Simplicity Detection System

NEXUS intelligently adapts to your project's complexity:
- **Simple Projects**: Learning tools, personal utilities, prototypes
  - Asks fewer questions during requirements gathering
  - Suggests minimal architectures (single file, basic structure)
  - Runs only core functionality tests
  - Disables sub-agent orchestration by default
- **Complex Projects**: Business applications, multi-service systems
  - Full requirements analysis
  - Comprehensive architecture planning
  - Complete test suites
  - Enables parallel development with sub-agents

Override simplicity detection with `--force` flags when needed.

### Pattern Library

NEXUS includes a curated library of battle-tested code patterns:
- **Automatic Injection**: Patterns are automatically applied during implementation
- **Categories**: API, Frontend, Testing, Database, Architecture, Security
- **Management**: Use `nexus 98-patterns` to browse and manage patterns
- **Quality Assured**: Each pattern includes tests and documentation

### Configuration System

Control NEXUS behavior through `.pris/config.yaml`:
```yaml
patterns:
  enabled: true                    # Enable/disable pattern injection
  max_patterns_per_query: 3        # Patterns per generation
  
testing:
  enabled: true                    # Automated test loops
  max_correction_attempts: 3       # Fix attempts for failing tests
  
orchestration:
  enabled: true                    # Parallel agent orchestration
  max_agents: 4                    # Maximum concurrent agents
  github_integration: true         # Use GitHub for coordination
```

## Quick Start Examples

### Single Agent Development
```bash
# 1. Initialize NEXUS system
# Use 00-initialize.md prompt with Claude
# This creates the .pris directory structure

# 2. Gather requirements (interactive)
# Use 01-discover.md prompt
# Claude will interview you about your project needs

# 3. Prioritize features (interactive)  
# Use 02-prioritize.md prompt
# Claude will help define MVP and create backlog

# 4. Select architecture pattern
# Use 03-architect.md prompt
# Claude will analyze requirements and select optimal architecture

# 5. Generate setup script
# Use 03-architect.md prompt
# Claude will implement the selected architecture

# 6. Run the generated setup script
./setup.sh my-project-name

# 7. Implement a feature
# Use 04-scaffold.md prompt with ticket ID
# Example: Implement FEAT-001 from backlog

# 8. Review code changes
# Use 12-review_code.md prompt with branch name
# Example: Review feat/FEAT-001-user-auth branch
```

### Parallel AI Agent Workflow (NEW!)

```bash
# 1. One-time setup: Initialize orchestration
# Use 08-setup_orchestration.md prompt
/NEXUS 08-setup_orchestration setup

# 2. Break down an epic into work contracts
# Use 09-decompose_epic.md prompt
/NEXUS 09-decompose_epic FEAT-001-auth

# 3. In multiple terminal windows (e.g., zellij):
# Each agent claims and works on contracts independently

# Terminal 1 - Agent 1:
/NEXUS 10-claim_work --claim
# Claims #101 [SHARED] Auth types
/NEXUS 04-scaffold 101
/NEXUS 11-create_handoff --complete

# Terminal 2 - Agent 2:
/NEXUS 10-claim_work --status
# Waits for #101 to complete, then:
/NEXUS 10-claim_work --claim 103
# Claims #103 [FRONTEND] Auth UI
/NEXUS 04-scaffold 103
/NEXUS 11-create_handoff --complete

# Terminal 3 - Agent 3:
/NEXUS 10-claim_work --claim 102
# Claims #102 [API] Auth endpoints
/NEXUS 04-scaffold 102
/NEXUS 11-create_handoff --complete

# 4. Agents automatically coordinate through AGENT_NOTES.md
# No merge conflicts due to architectural boundaries!
```



## Best Practices

1. **Follow the Flow**: Commands build on each other - don't skip phases
2. **Trust the Process**: Let each specialist complete their analysis
3. **Provide Context**: The more detailed your requirements, the better the output
4. **Review and Validate**: Always review generated code and decisions
5. **Use Living Documents**: Check `memories/` folder for latest state
6. **Parallel Development**: Use orchestration for complex features with clear boundaries
7. **Pattern Library**: Review patterns before implementation for consistency
8. **Simplicity Mode**: Let NEXUS auto-detect project complexity for optimal workflow

## Development Philosophy

NEXUS embraces modern AI-assisted development:
- **"When machines think together"** - Collaborative AI development
- **"Architecture coherent"** - Systematic, well-planned systems
- **"Agents synchronized"** - Coordinated parallel development
- **"Knowledge preserved"** - Documentation throughout the lifecycle

## License

MIT License - See LICENSE file for details

---

*"The future of development is not replacing humans with machines, but enabling humans and machines to work together seamlessly."*