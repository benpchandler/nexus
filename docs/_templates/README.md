# Documentation Templates

This directory contains numbered templates for documentation used throughout the NEXUS workflow. Templates are numbered in the order they are typically used during development.

## Template Usage Order

### Phase 1: Requirements & Vision (voight-kampff)
- **00-VISION-template.md** - Product vision for new products/platforms
- **01-PRD-template.md** - Product Requirements Documents for features

### Phase 2: Architecture & Design (tyrell)
- **02-TDD-template.md** - Technical Design Documents
- **03-ADR-template.md** - Architecture Decision Records (major decisions)
- **03a-ADR-micro-template.md** - Micro ADRs (quick decisions)

### Phase 3: Implementation (construct)
- **04-QUICK-DECISION-template.md** - Quick implementation decisions

### Phase 4: Project Setup (sebastian)
- **05-CLAUDE-platform-overview-template.md** - Root AI context
- **06-CLAUDE-platform-service-template.md** - Service-level AI context
- **07-CLAUDE-feature-template.md** - Feature-level AI context
- **08-CLAUDE-project-template.md** - Overall project AI context

## Template Descriptions

### Strategic Documents (00-01)
**00-VISION-template.md**
- **Purpose**: Define 3-5 year product strategy
- **When**: New product/platform discussions
- **Location**: `docs/00-platform/vision/`

**01-PRD-template.md**
- **Purpose**: Define what we're building and why
- **When**: Feature requirements gathering
- **Location**: `docs/01-core-features/[name]/` or `docs/02-business-features/[name]/`

### Technical Documents (02-04)
**02-TDD-template.md**
- **Purpose**: Define how we'll build it technically
- **When**: After architecture selection
- **Location**: Same as feature or `docs/00-platform/architecture/`

**03-ADR-template.md**
- **Purpose**: Document major architectural decisions
- **When**: Significant technical choices
- **Location**: `docs/[component]/decisions/`

**03a-ADR-micro-template.md**
- **Purpose**: Document small, quick decisions
- **When**: Minor technical choices
- **Location**: `docs/[component]/decisions/`

**04-QUICK-DECISION-template.md**
- **Purpose**: Capture implementation decisions
- **When**: During coding
- **Location**: `docs/[component]/decisions/`

### AI Context Documents (05-08)
**05-CLAUDE-platform-overview-template.md**
- **Purpose**: Overall system context for AI
- **Location**: Root `/CLAUDE.md`

**06-CLAUDE-platform-service-template.md**
- **Purpose**: Service-specific AI context
- **Location**: `services/[name]/CLAUDE.md`

**07-CLAUDE-feature-template.md**
- **Purpose**: Feature-specific AI context
- **Location**: `features/[name]/CLAUDE.md`

**08-CLAUDE-project-template.md**
- **Purpose**: Complete project AI context
- **Location**: Project root or docs

## Quick Start Guide

### Starting a New Feature
```bash
# 1. Create PRD from template
cp 01-PRD-template.md ../01-core-features/auth/PRD-authentication.md

# 2. After architecture, create TDD
cp 02-TDD-template.md ../01-core-features/auth/TDD-auth-system.md

# 3. During setup, create CLAUDE.md
cp 07-CLAUDE-feature-template.md ../../../features/auth/CLAUDE.md
```

### Making Architecture Decisions
```bash
# Major decision
cp 03-ADR-template.md ../00-platform/decisions/ADR-001-database-choice.md

# Quick decision
cp 04-QUICK-DECISION-template.md ../01-core-features/auth/decisions/DECISION-20240117-jwt-library.md
```

## Template Best Practices

1. **Keep Templates Current**: Update based on usage patterns
2. **Pre-populate When Possible**: NEXUS commands should fill in known information
3. **Document Sparingly**: Only document what adds value
4. **Cross-Reference**: Link related documents
5. **Version Control**: Track template changes

## Template Maintenance

- Review quarterly for relevance
- Update based on team feedback
- Remove unused sections
- Add new patterns as they emerge

---

*Templates follow NEXUS workflow: Requirements → Design → Implementation → Context*