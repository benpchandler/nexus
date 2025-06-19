# Developer Documentation Best Practices

*Based on research from top tech companies including Google, Microsoft, Amazon, and Spotify*

## 1. Folder Structure Evolution

### Recommended: Hierarchical Vertical Slice Architecture
```
docs/
├── 00-platform/                    # Foundation & cross-cutting concerns
│   ├── 01-architecture/
│   │   ├── ADR-001-project-inception.md
│   │   ├── ADR-002-tech-stack-selection.md
│   │   └── system-overview.md
│   ├── 02-standards/
│   │   ├── coding-standards.md
│   │   ├── api-design-guide.md
│   │   └── documentation-standards.md
│   ├── 03-infrastructure/
│   │   ├── local-development-setup.md
│   │   ├── environments.md
│   │   └── ci-cd-pipeline.md
│   ├── 04-tooling/
│   │   ├── linting-and-formatting.md
│   │   └── required-tools.md
│   └── 05-automation/
│       └── pris-integration.md
│
├── 01-core-features/              # Essential system features
│   ├── 01-user-authentication/
│   │   ├── README.md
│   │   ├── PRD-2025-01-initial.md
│   │   ├── TDD-2025-01-api-design.md
│   │   ├── research/
│   │   ├── decisions/
│   │   ├── designs/
│   │   └── changes/
│   └── 02-authorization/
│
├── 02-business-features/          # Business logic features
│   ├── 01-payment-processing/
│   └── 02-reporting-dashboard/
│
├── 99-archive/                    # Historical/deprecated
│   └── 2024/
│
├── _templates/                    # Document templates
│   ├── 01-PRD-template.md
│   ├── 02-TDD-template.md
│   └── 03-ADR-template.md
│
└── README.md                      # Documentation index
```

### Folder Naming Conventions
- **Numeric Prefixes**: `00-99` for consistent sorting
- **Semantic Groups**: 
  - `00-*` = Platform/foundation
  - `01-*` = Core features (auth, data, etc.)
  - `02-*` = Business features
  - `99-*` = Archive/deprecated
- **Kebab-Case**: `feature-name` for readability

### Platform vs Feature Guidelines

#### What Goes in Platform (`00-platform/`)
- **Architecture**: System-wide patterns, database choices, API strategies
- **Standards**: Coding conventions, security policies, design systems
- **Infrastructure**: Deployment, monitoring, CI/CD, environments
- **Tooling**: Development setup, shared libraries, build tools
- **Cross-cutting ADRs**: Decisions affecting multiple features

#### What Constitutes a Feature
- **Self-contained functionality**: Can be developed/deployed independently
- **Own lifecycle**: Has distinct PRD, TDD, and release cycle
- **Clear boundaries**: Minimal dependencies on other features
- **Team ownership**: Can be assigned to a specific team

#### Core vs Business Features
**Core Features (`01-core-features/`)**
- Authentication & authorization
- Data persistence & caching
- Logging & monitoring
- API gateway & routing
- Common UI components

**Business Features (`02-business-features/`)**
- User-facing functionality
- Business logic implementation
- Domain-specific workflows
- Customer features

## 2. Document Lifecycle Management

### Static vs Dynamic Documents
**Static (Immutable)**
- ADRs - append-only decision logs
- Release notes - fixed at release time
- Historical PRDs - snapshot at approval

**Dynamic (Living)**
- Current PRDs - updated throughout lifecycle
- API documentation - reflects current state
- Setup guides - maintained with codebase

### Version Control Approach
1. **Living Documents**: Update in-place with change history
2. **Milestone Documents**: Create versioned copies at major releases
3. **Decision Records**: Append-only with timestamps

## 3. Naming Conventions

### Document Naming Patterns

#### File Naming Within Features
```
01-user-authentication/
├── README.md                      # Feature overview & status
├── PRD-2025-01-initial.md        # Product requirements
├── TDD-2025-01-api-design.md     # Technical design
├── TDD-2025-02-database.md       # Additional technical docs
├── research/
│   ├── 2025-01-15-competitor-analysis.md
│   └── 2025-01-20-user-interviews.md
├── decisions/
│   ├── ADR-001-jwt-implementation.md
│   └── ADR-002-session-storage.md
├── designs/
│   ├── 2025-01-10-wireframes.fig
│   └── 2025-02-01-final-designs.fig
└── changes/
    ├── 2025-02-15-add-2fa.md
    └── 2025-03-01-biometric-support.md
```

#### Naming Formats
```
# Product Requirements
PRD-YYYY-MM-description.md

# Technical Design  
TDD-YYYY-MM-component.md

# Architecture Decisions (sequential within context)
ADR-NNN-decision-topic.md

# Research & Analysis
YYYY-MM-DD-research-topic.md

# Changes/Updates
YYYY-MM-DD-change-description.md
```

### Key Principles
- Include dates in YYYY-MM-DD format for chronological sorting
- Use feature-local numbering for ADRs (resets per feature)
- Platform ADRs use global numbering
- Descriptive slugs after identifiers
- No special status suffixes (use README.md for current status)

## 4. Documentation Update Strategy

### When to Update vs Create New
**Update Existing:**
- Minor clarifications
- Bug fixes in examples
- Updated contact info
- Non-breaking changes

**Create New Version:**
- Major architectural changes
- Breaking API changes
- Significant requirement shifts
- Legal/compliance updates

### Change Tracking
```markdown
## Change History
| Date | Author | Version | Description |
|------|--------|---------|-------------|
| 2025-01-15 | @jane | 1.0 | Initial version |
| 2025-01-20 | @john | 1.1 | Added security requirements |
| 2025-02-01 | @jane | 2.0 | Major architecture revision |
```

## 5. Decision Documentation (ADRs)

### ADR Template
```markdown
# ADR-XXX: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-YYY]

## Context
What is the issue we're facing?

## Decision
What are we going to do?

## Consequences
What happens as a result?

## Alternatives Considered
What else did we evaluate?
```

### Best Practices
- Write ADRs for architecturally significant decisions
- Review ADRs monthly after creation
- Link ADRs in code reviews
- Store in version control with code

## 6. Tools and Automation

### Recommended Tooling
- **Version Control**: Git for all documentation
- **Collaboration**: Confluence/Notion for drafts
- **Diagrams**: Mermaid/PlantUML (version-controlled)
- **API Docs**: OpenAPI/Swagger (generated from code)

### Automation Opportunities
- Auto-generate API docs from code
- Link PRs to relevant documentation
- Set up documentation review cycles
- Create templates for consistency

## 7. Quick Reference System

### Visual Indicators
- 🟢 CURRENT - Active document
- 🟡 DRAFT - Under review
- 🔴 DEPRECATED - Replaced by newer version
- 📁 ARCHIVED - Historical reference only

### Discovery Aids

#### For Vertical Slice Architecture
```markdown
# docs/index.md - Documentation Index

## Active Features
- [User Authentication](features/user-authentication/) - *Owner: Auth Team*
- [Payment Processing](features/payment-processing/) - *Owner: Payments Team*

## Platform Documentation
- [Architecture Decisions](platform/architecture/)
- [Development Standards](platform/standards/)

## Quick Links
- [Latest ADRs](platform/architecture/#recent-decisions)
- [API Documentation](platform/standards/api-design-guide.md)
```

#### Feature README Template
```markdown
# Feature: User Authentication

## Status: Production
## Owner: Auth Team
## Last Updated: 2025-03-01

## Documents
- [Product Requirements](PRD-2025-01-user-auth.md)
- [Technical Design](TDD-2025-01-auth-service.md)
- [Architecture Decisions](decisions/)
- [Updates & Changes](updates/)

## Related Features
- [User Profile Management](../user-profile/)
- [Session Management](../session-management/)
```

### Cross-Reference System
```markdown
<!-- In payment-processing/PRD-2025-02-payment-integration.md -->
## Dependencies
- Requires: [User Authentication](../user-authentication/PRD-2025-01-user-auth.md)
- See also: [Platform Database Decision](../../platform/architecture/ADR-003-database-selection.md)
```

## 8. Review and Maintenance

### Regular Reviews
- Monthly: Review recent ADRs against implementation
- Quarterly: Audit living documents for accuracy
- Annually: Archive obsolete documentation

### Team Responsibilities
- **Product Manager**: Owns PRDs
- **Tech Lead**: Owns TDDs and ADRs
- **DevOps**: Owns deployment/operational docs
- **Whole Team**: Reviews and suggests updates

## 9. Essential Pre-Populated Documentation

### Always Include - Platform Foundation

#### 00-platform/01-architecture/
```
ADR-001-project-inception.md          # Why this project exists, key constraints
ADR-002-tech-stack-selection.md       # Language, framework, database choices
ADR-003-deployment-strategy.md        # Where/how we deploy
ADR-004-vertical-slice-architecture.md # Documentation structure decision
system-overview.md                    # High-level architecture diagram
```

#### 00-platform/02-standards/
```
coding-standards.md                   # Language-specific conventions
api-design-guide.md                   # REST/GraphQL patterns, versioning
git-workflow.md                       # Branching, PR, commit conventions
documentation-standards.md            # How to write docs (this guide!)
testing-standards.md                  # Test coverage, naming, structure
security-checklist.md                 # OWASP, auth patterns, secrets management
```

#### 00-platform/03-infrastructure/
```
local-development-setup.md            # Getting started guide
environments.md                       # Dev, staging, prod configurations
ci-cd-pipeline.md                     # Build and deployment automation
monitoring-and-alerts.md              # Observability setup
```

#### 00-platform/04-tooling/
```
linting-and-formatting.md             # ESLint, Prettier, Ruff configs
dependency-management.md              # Package managers, update policies
ide-setup.md                          # VS Code settings, extensions
required-tools.md                     # mise, Docker, etc.
```

### Document Templates

#### PRD Template
```markdown
# PRD: [Feature Name]

## Status: [Draft | In Review | Approved]
## Version: 1.0
## Last Updated: YYYY-MM-DD

## Problem Statement
What problem are we solving?

## Success Criteria
How do we measure success?

## User Stories
As a [user type], I want [goal], so that [benefit]

## Requirements
### Functional Requirements
- [ ] Requirement 1
- [ ] Requirement 2

### Non-Functional Requirements
- Performance: 
- Security:
- Accessibility:

## Out of Scope
What are we explicitly NOT doing?

## Dependencies
- Platform: [links to platform docs]
- Features: [links to feature dependencies]

## Timeline
- Design Complete: YYYY-MM-DD
- Development Start: YYYY-MM-DD
- Target Release: YYYY-MM-DD
```

#### TDD Template
```markdown
# TDD: [Component Name]

## Status: [Draft | In Review | Approved]
## Version: 1.0
## Last Updated: YYYY-MM-DD

## Overview
Brief technical summary

## Architecture
### Component Diagram
[Mermaid or link to diagram]

### Data Model
[Schema definition]

### API Design
[Endpoints, contracts]

## Implementation Plan
1. Phase 1: [Description]
2. Phase 2: [Description]

## Testing Strategy
- Unit Tests:
- Integration Tests:
- E2E Tests:

## Performance Considerations
- Expected load:
- Caching strategy:
- Database indexes:

## Security Considerations
- Authentication:
- Authorization:
- Data protection:

## Deployment
- Migration plan:
- Feature flags:
- Rollback strategy:
```

#### ADR Template
```markdown
# ADR-XXX: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-YYY]

## Context
What is the issue we're facing?

## Decision
What are we going to do?

## Consequences
What happens as a result?

## Alternatives Considered
What else did we evaluate?
```

### PRIS Integration
```
00-platform/05-automation/
├── pris-integration.md               # How PRIS uses these docs
├── doc-generation-rules.md           # Auto-generation from code
├── validation-rules.md               # Doc completeness checks
└── update-triggers.md                # When to prompt for updates
```

### Minimal Viable Documentation Set
```
docs/
├── 00-platform/
│   ├── 01-architecture/
│   │   └── ADR-001-project-inception.md
│   ├── 02-standards/
│   │   ├── coding-standards.md
│   │   └── git-workflow.md
│   └── 03-infrastructure/
│       └── local-development-setup.md
├── _templates/
│   ├── 01-PRD-template.md
│   ├── 02-TDD-template.md
│   └── 03-ADR-template.md
└── README.md (index)
```

## Key Insights from Tech Companies

### Google's Approach
- Avoids duplicate documentation, links to existing resources
- Documents practical details (arguments, returns, exceptions)
- Uses folders for hierarchical organization (up to 10 levels)
- Enforces unique naming within hierarchy levels

### Amazon's Practices  
- Uses Google Docs for structured communication
- Emphasizes clear thinking through written documentation
- Provides AWS architecture center with best practices

### Microsoft's Methods
- Treats ADRs as append-only logs throughout workload lifespan
- Provides comprehensive templates via GitHub
- Emphasizes continuous documentation updates

### Spotify's Implementation
- Uses ADRs to reduce context loss during organizational changes
- Integrates ADRs into code review processes
- Treats documentation as living documents with timestamps

## Modern Documentation Trends

1. **Centralized Systems**: Moving away from distributed Word documents
2. **Living Documents**: Evolution with product lifecycle
3. **Clear Change Tracking**: Who/what/when information
4. **Lean Approaches**: Aligned with agile methodologies
5. **Standardized Templates**: Consistency across teams
6. **Git Integration**: Documentation as code
7. **Automated Generation**: API docs from code annotations
8. **Review Integration**: Documentation linked to PRs

## Vertical Slice Architecture Benefits

### Feature Cohesion
- All context for a feature in one place
- Easier onboarding for feature teams
- Clear ownership boundaries
- Natural archival unit when features retire

### Microservices Alignment
- Documentation mirrors service boundaries
- Features self-contained like microservices
- Deploy features with their documentation
- Simplified archival of entire features

This approach balances the need for historical records with practical maintenance, ensuring documentation remains useful while preserving important context and decisions. The vertical slice architecture treats documentation as a first-class citizen of the feature, ensuring all related information travels together through the development lifecycle.