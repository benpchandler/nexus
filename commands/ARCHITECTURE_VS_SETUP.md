# Architecture Selection vs Setup Implementation

## Overview

PRIS separates architecture decisions from implementation to ensure thoughtful technology choices before any code is written. This document clarifies when to use each command.

## Command Comparison

### 025-architecture: The Architect
**Role**: Makes strategic technology decisions

### 03-tyrell: The Builder
**Role**: Implements those decisions

## When to Use 025-architecture

Use this command when you need to:
- Decide which technology stack to use
- Choose between different architecture patterns
- Research current versions of libraries/frameworks
- Document architecture decisions
- Evaluate technology trade-offs

**You should have**:
- Completed requirements analysis (01)
- Prioritized features (02)
- Clear understanding of:
  - Performance requirements
  - Team expertise
  - Scalability needs
  - Integration requirements

**You will get**:
- Architecture Decision Record (ADR)
- Technology stack with specific versions
- Pattern selection (monolith, microservices, etc.)
- Implementation roadmap
- Risk assessment

**Example scenarios**:
- "Should we use Next.js or vanilla React?"
- "What database is best for our use case?"
- "Which architecture pattern fits our team?"
- "What are the latest stable versions?"

## When to Use 03-tyrell

Use this command when you need to:
- Create the actual project structure
- Generate setup scripts
- Initialize the development environment
- Configure selected technologies
- Implement the chosen architecture

**You MUST have**:
- Architecture decision from 025
- The file `.pris/memories/_30-ARCHITECTURE.md` must exist
- All technology choices already made

**You will get**:
- Executable `setup.sh` script
- Project directory structure
- Configuration files
- Development environment setup
- Getting started documentation

**Example outputs**:
- Package.json with exact versions
- Docker configuration
- Database initialization scripts
- Environment variable templates
- Git repository structure

## Key Differences

| Aspect | 025-architecture | 03-tyrell |
|--------|-----------------|----------|
| **Purpose** | Decide WHAT to build with | BUILD it |
| **Output** | Decisions & documentation | Code & scripts |
| **Thinking** | Strategic & evaluative | Tactical & implementative |
| **Questions** | "Which technology?" | "How to configure?" |
| **Flexibility** | Explores options | Follows decisions |

## The Workflow

```mermaid
graph LR
    A[01-voight-kampff] --> B[02-joshi]
    B --> C[025-architecture]
    C --> D[03-tyrell]
    
    style C fill:#f9f,stroke:#333,stroke-width:4px
    style D fill:#bbf,stroke:#333,stroke-width:4px
```

1. **Analyze** (01): Understand what you're building
2. **Prioritize** (02): Decide what to build first
3. **Architecture** (025): Decide how to build it
4. **Setup** (03): Actually build it

## Common Mistakes to Avoid

### ❌ DON'T skip 025-architecture
Going straight to setup means making architecture decisions on the fly, which leads to:
- Inconsistent technology choices
- Missing version research
- No documented rationale
- Harder to justify decisions later

### ❌ DON'T use 03-tyrell for architecture changes
If you realize you need different technology:
1. Stop the setup process
2. Re-run 025-architecture with new requirements
3. Then run 03-tyrell with the new decision

### ❌ DON'T manually edit architecture decisions
The architecture decision should come from 025-architecture, not be manually created or edited before running setup.

## Real-World Analogy

Think of building a house:

**025-architecture** = The Architect
- Draws blueprints
- Selects materials
- Chooses structural approach
- Documents why these choices

**03-tyrell** = The General Contractor
- Orders the exact materials specified
- Hires the right workers
- Builds according to blueprints
- Doesn't change the design

## Quick Decision Guide

Ask yourself:
- "Do I know exactly what technologies and versions to use?" 
  - No → Use 025-architecture
  - Yes → Use 03-tyrell

- "Is there an architecture decision in `.pris/memories/_30-ARCHITECTURE.md`?"
  - No → Use 025-architecture first
  - Yes → Use 03-tyrell

- "Do I need to evaluate different options?"
  - Yes → Use 025-architecture
  - No → Use 03-tyrell

## Command Dependencies

```
025-architecture requires:
- _10-REQUIREMENTS.md (from 01-voight-kampff)
- _20-BACKLOG.md (from 02-joshi)

03-tyrell requires:
- _30-ARCHITECTURE.md (from 025-architecture)
- All files required by 025-architecture
```

## Summary

- **025-architecture**: Makes decisions, documents why
- **03-tyrell**: Implements decisions, creates code

Always run them in order. The separation ensures thoughtful, documented technology choices before any implementation begins.