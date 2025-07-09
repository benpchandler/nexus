# NEXUS - Custom Claude Code Slash Commands

*Advanced AI-powered development workflow system for Claude Code*

## What is NEXUS?

NEXUS is a collection of custom slash commands for Claude Code that provides structured prompts and workflows for software development tasks. Each command represents a specialized prompt template designed to guide AI assistants through specific development activities with best practices and systematic approaches.

## Version

**Current Version: 2.0.0**

### Key Features
- 🚀 Structured development workflows from requirements to deployment
- 🤖 Specialized command templates for different development phases
- 📋 Educational approach with objective checklists for deterministic output
- 🔄 Current best practices research integrated into workflows
- ⚡ Todo-list format for clear actionable steps
- 🎯 Scalable across project types (MVP to enterprise)

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/benpchandler/nexus.git
cd nexus
```

2. The commands are ready to use in Claude Code as slash commands

### Project Structure

```
your-project/
├── .claude/
│   ├── commands/nexus/       # NEXUS command templates
│   └── .nexus/              # Generated workspace (created by /nexus:00-initiate)
│       ├── 01-requirements/  # Requirements documents
│       ├── 02-products/      # PRDs and prioritization
│       ├── 03-tech_design/   # Technical specifications
│       ├── 04-code/         # Code artifacts
│       ├── 05-reviews/      # Code review feedback
│       ├── 06-updates/      # Code update implementations
│       ├── 07-approvals/    # Technical approval decisions
│       ├── templates/       # Project-specific coding standards
│       └── progress.json    # Workflow tracking
└── src/                     # Your actual project code
```

## Core Commands

NEXUS provides 8 numbered commands for systematic development:

### Setup & Requirements
- `/nexus:00-initiate` - Initialize NEXUS workspace structure
- `/nexus:01-requirements_gathering` - Interactive requirements gathering with validation
- `/nexus:02-productization` - Transform requirements into PRDs with RICE prioritization

### Technical Design & Implementation  
- `/nexus:03-tech_design` - Technical architecture with current best practices research
- `/nexus:04-code_creator` - TDD-focused implementation with quality checkpoints
- `/nexus:05-code_reviewer` - Educational code review for iterative improvement

### Quality & Approval
- `/nexus:06-codeUpdater` - Systematic code improvements based on feedback
- `/nexus:07-tech_reviewer` - Final technical approval with production readiness assessment

## Usage

### Getting Started
1. Initialize your project workspace:
   ```
   /nexus:00-initiate
   ```

2. Gather requirements:
   ```
   /nexus:01-requirements_gathering
   ```

3. Follow the systematic workflow through all 8 commands

### Command Features
- **Objective Checklists**: Clear, actionable items instead of vague guidance
- **Current Standards Research**: Commands research latest best practices before recommendations
- **Educational Focus**: Code review emphasizes learning and growth over gatekeeping
- **Universal Approach**: Works across project types from MVPs to enterprise systems

## Workflow

1. **Initialize**: Set up workspace structure and progress tracking
2. **Requirements**: Gather and validate user needs systematically  
3. **Productize**: Create PRD with feature prioritization using RICE scoring
4. **Design**: Create technical architecture with current best practices
5. **Implement**: Build features using TDD with quality checkpoints
6. **Review**: Educational code review focusing on learning and improvement
7. **Update**: Systematic implementation of feedback and improvements
8. **Approve**: Final technical assessment for production readiness

## Key Improvements in v2.0

### Deterministic Output
- Transformed prose into actionable checklists
- Objective criteria replace subjective assessments
- Consistent workflow across different users and projects

### Educational Approach
- Code review focuses on teaching principles, not just fixing problems
- Research current best practices before making recommendations
- Build team expertise through iterative improvement

### Scalability
- Works for vision-stage projects through enterprise systems
- Universal PRD quality framework handles all project types
- Reference `.nexus/templates/` for language-specific standards

## Documentation

- Commands include comprehensive examples and usage guidance
- Each command has clear role definitions and expected outputs
- Progress tracking maintains momentum across development phases

## Contributing

NEXUS is designed to be extended. When adding new commands:
1. Follow the numbered naming convention (`XX-name.md`)
2. Use todo-list format for actionable steps
3. Include objective validation criteria
4. Add comprehensive examples

## License

[Apache 2.0 with Commons Clause](LICENSE)

This means:
- ✅ Free to use, modify, and distribute
- ✅ Use in personal projects
- ✅ Use in internal company projects
- ❌ Cannot sell NEXUS or offer it as a paid service
- ❌ Cannot charge for hosting or consulting services where NEXUS is the primary value

For commercial licensing inquiries, please contact the author.

## Support

- Issues: [GitHub Issues](https://github.com/benpchandler/nexus/issues)
- Documentation: Available within each command

---

*NEXUS - Making AI-assisted development systematic and reliable*