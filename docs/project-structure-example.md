# PRIS Project Documentation Structure Example

This shows how documentation should be organized in a project using PRIS.

```
project-root/
├── .nexus/                          # PRIS system files
│   ├── memories/                   # Living documents
│   │   ├── _10-REQUIREMENTS.md    # Current requirements
│   │   ├── _20-BACKLOG.md         # Prioritized backlog
│   │   ├── _30-ARCHITECTURE.md    # Architecture decisions
│   │   └── _DOCUMENTATION.md      # Documentation index
│   └── history/                    # Historical snapshots
├── CLAUDE.md                       # Root AI context
├── docs/                           # All project documentation
│   ├── 00-platform/                # Platform-wide docs
│   │   ├── vision/                 # Product vision
│   │   │   └── PRODUCT-VISION.md  # Created from 00-VISION-template.md
│   │   ├── architecture/           # System architecture
│   │   │   └── TDD-system.md      # Created from 02-TDD-template.md
│   │   └── decisions/              # Architecture decisions
│   │       ├── ADR-001-monolith.md # Created from 03-ADR-template.md
│   │       └── ADR-002-postgres.md
│   ├── 01-core-features/           # Essential features
│   │   ├── authentication/
│   │   │   ├── PRD-auth.md        # Created from 01-PRD-template.md
│   │   │   ├── TDD-auth.md        # Created from 02-TDD-template.md
│   │   │   └── decisions/
│   │   │       └── DECISION-20240117-jwt.md # From 04-QUICK-DECISION-template.md
│   │   └── billing/
│   │       ├── PRD-billing.md
│   │       └── TDD-billing.md
│   ├── 02-business-features/       # Business logic features
│   │   └── reporting/
│   │       ├── PRD-analytics.md
│   │       └── TDD-reporting.md
│   └── 99-archive/                 # Old/deprecated docs
│       └── 2023/
│           └── OLD-API-DESIGN.md
├── services/                       # Backend services
│   ├── auth/
│   │   └── CLAUDE.md              # From 06-CLAUDE-platform-service-template.md
│   └── billing/
│       └── CLAUDE.md
└── frontend/
    └── features/
        ├── dashboard/
        │   └── CLAUDE.md          # From 07-CLAUDE-feature-template.md
        └── profile/
            └── CLAUDE.md
```

## Key Principles

### 1. Document Numbering
- **00-** Platform/foundation documents
- **01-** Core features (essential for MVP)
- **02-** Business features (added value)
- **99-** Archive (old/deprecated)

### 2. Living vs Static Documents
- **Living** (in .nexus/memories/): Requirements, backlog, current state
- **Static** (in docs/): PRDs, TDDs, ADRs, decisions

### 3. AI Context (CLAUDE.md)
- Place at the root of each major component
- Links to relevant PRDs, TDDs, and decisions
- Updates when patterns change

### 4. Decision Documentation
- **ADRs**: Major architecture decisions (immutable)
- **Quick Decisions**: Implementation choices (immutable)
- Create new documents to revise, never modify

### 5. Archive Strategy
- Move outdated docs to 99-archive/[year]/
- Keep for historical reference
- Clear separation from active docs

## Document Creation Flow

1. **Requirements** (voight-kampff) → Vision/PRDs
2. **Architecture** (tyrell) → TDD/ADRs  
3. **Setup** (sebastian) → CLAUDE.md files
4. **Implementation** (construct) → Quick Decisions
5. **Updates** → New versions, not modifications

This structure ensures all documentation is:
- Easy to find (numbered and organized)
- Current (living docs in .nexus/memories/)
- Traceable (cross-referenced)
- AI-friendly (CLAUDE.md context)