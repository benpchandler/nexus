# PRIS Command Mapping

## JIM → PRIS Command Conversion

| Original JIM Command | New PRIS Command | Character/Concept |
|---------------------|------------------|-------------------|
| `00-init` | `00-baseline` | Baseline test (also validates) |
| `01-analyze` | `01-voight-kampff` | Requirements empathy test |
| `02-prioritize` | `02-joshi` | Lieutenant assigns priorities |
| `025-architecture` | `03-tyrell` | The architect designs |
| `03-setup` | `04-sebastian` | The builder implements |
| `030-orchestrate` | `05-wallace` | Orchestrating operations |
| `035-decompose` | `06-cells` | Breaking into cells |
| `04-implement` | `07-construct` | Building features |
| `040-sync` | `08-mesh` | Syncing agents |
| `045-coordinate` | `09-stelline` | Memory designer handoffs |
| `05-review` | `10-deckard` | Investigating/reviewing |
| `15-validate` | `11-vk` | Quick validation test |
| `90-improve-prompts` | `12-morehuman` | More human than human |
| `90-migrate` | `13-tearsInRain` | Preserving through change |
| `95-validate-structure` | *(merged into 00-baseline)* | - |

## Key Changes

1. **Merged Commands**: `00-init` and `95-validate-structure` are now both handled by `00-baseline`
2. **Renumbered**: Commands are now sequentially numbered 00-13
3. **Character-based**: Each command references a Blade Runner character or concept
4. **Multi-modal**: `10-deckard` now handles all types of reviews (code, docs, PRs, architecture)

## Usage Examples

```bash
# Old JIM way
jim 00-init
jim 01-analyze

# New PRIS way  
pris 00-baseline
pris 01-voight-kampff

# Deckard's multi-modal review
pris 10-deckard --pr 123
pris 10-deckard --doc requirements.md
pris 10-deckard --security
```