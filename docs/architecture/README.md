# Architecture Documentation

This directory contains architecture-related documentation for PRIS and projects built with PRIS.

## Contents

- **Architecture Decision Records (ADRs)**: Document significant architectural decisions
- **System Architecture**: Overall PRIS system design and component interactions
- **Pattern Library**: Reusable architectural patterns identified across projects

## Using ADR Templates

PRIS provides two ADR templates in `docs/_templates/`:

1. **03-ADR-template.md**: Full Architecture Decision Record template
   - Use for significant architectural decisions
   - Includes context, decision, consequences, and alternatives

2. **03a-ADR-micro-template.md**: Lightweight micro-ADR template
   - Use for smaller, focused decisions
   - Quick format for rapid decision documentation

## Best Practices

1. Number ADRs sequentially (e.g., `001-use-event-sourcing.md`)
2. Keep ADRs immutable once accepted
3. Create new ADRs to supersede old ones rather than editing
4. Link related ADRs together
5. Include diagrams when they clarify the architecture

## PRIS Architecture Commands

- **07-construct**: Selects optimal architecture patterns based on requirements
- **03-tyrell**: Implements the selected architecture with setup scripts

These commands automatically generate architecture documentation in the appropriate format.