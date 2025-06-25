# Project Documentation Index

## Overview
Central index for all project documentation. This living document tracks the location, status, and relationships between all documentation artifacts.

## Vision & Strategy
| Document | Location | Status | Last Updated | Notes |
|----------|----------|--------|--------------|-------|
| Product Vision | - | Not Created | - | Create after requirements gathering for new products |
| 3-Year Roadmap | - | Not Created | - | Part of vision document |

## Product Requirements (PRDs)
| Feature | Location | Status | Implementation | Last Updated |
|---------|----------|--------|----------------|--------------|
| Example: Auth System | - | Not Created | - | - |

## Technical Design (TDDs)
| Component | Location | Status | PRD Link | Last Updated |
|-----------|----------|--------|----------|--------------|
| System Architecture | - | Not Created | - | Create after architecture selection |

## Architecture Decisions (ADRs)
| ID | Decision | Location | Status | TDD Link |
|----|----------|----------|--------|----------|
| ADR-001 | - | - | - | - |

## Quick Decisions
| Date | Topic | Location | Impact | Related To |
|------|-------|----------|--------|------------|
| - | - | - | - | - |

## AI Context (CLAUDE.md)
| Component | Location | Type | Related Docs | Last Updated |
|-----------|----------|------|--------------|--------------|
| Platform Overview | /CLAUDE.md | Platform | All | - |

## Documentation Templates
| Template | Purpose | Location |
|----------|---------|----------|
| Vision | 3-5 year product strategy | docs/_templates/00-VISION-template.md |
| PRD | Feature requirements | docs/_templates/01-PRD-template.md |
| TDD | Technical design | docs/_templates/02-TDD-template.md |
| ADR | Architecture decisions | docs/_templates/03-ADR-template.md |
| ADR Micro | Quick architecture decisions | docs/_templates/03a-ADR-micro-template.md |
| Quick Decision | Small implementation choices | docs/_templates/04-QUICK-DECISION-template.md |
| CLAUDE Platform Overview | Root AI context | docs/_templates/05-CLAUDE-platform-overview-template.md |
| CLAUDE Platform Service | Service AI context | docs/_templates/06-CLAUDE-platform-service-template.md |
| CLAUDE Feature | AI context for features | docs/_templates/07-CLAUDE-feature-template.md |
| CLAUDE Project | Overall project AI context | docs/_templates/08-CLAUDE-project-template.md |

## Documentation Guidelines

### When to Create Each Document Type

**Vision Document**
- Triggered by: New product or major pivot discussions in discover
- Created at: docs/00-platform/vision/
- Updated: Quarterly or on major strategy changes

**PRD (Product Requirements Document)**
- Triggered by: Feature-level requirements in discover
- Created at: docs/01-core-features/[name]/ or docs/02-business-features/[name]/
- Updated: Before implementation begins, locked during development

**TDD (Technical Design Document)**
- Triggered by: Architecture selection in architect
- Created at: Same directory as feature or docs/00-platform/ for system-wide
- Updated: During implementation to track progress

**ADR (Architecture Decision Record)**
- Triggered by: Major technical decisions in architect
- Created at: docs/[component]/decisions/
- Updated: Never (immutable) - create new ADRs to revise

**Quick Decision**
- Triggered by: Implementation choices in construct phase
- Created at: docs/[component]/decisions/
- Updated: Never (immutable)

**CLAUDE.md**
- Triggered by: Directory creation in scaffold
- Created at: Same directory as code
- Updated: When patterns or conventions change

### Documentation Health Metrics
- [ ] All features have PRDs before implementation
- [ ] All major decisions have ADRs
- [ ] All components have CLAUDE.md files
- [ ] Cross-references are current
- [ ] No broken links
- [ ] Review quarterly for staleness

### Notes
- This index is automatically updated by NEXUS commands
- Manual updates may be needed for external changes
- Archive outdated docs to docs/99-archive/