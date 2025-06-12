# PRIS - Polymorphic Reality Implementation System

*"I've seen things you people wouldn't believe... All those moments will be lost in time, like tears in rain... Unless you track them with PRIS."*

## What is PRIS?

PRIS (Polymorphic Reality Implementation System) is an AI-powered development workflow system inspired by Blade Runner. It manages the software development lifecycle through distinct phases, each named after characters and concepts from the Blade Runner universe.

## Installation

### As a Git Submodule (Recommended)

```bash
# Add PRIS to your project
git submodule add https://github.com/benpchandler/pris.git .pris
git commit -m "Add PRIS as submodule"

# Initialize PRIS
pris 00-baseline
```

### For Fresh Clones

```bash
git clone --recurse-submodules https://github.com/your-username/your-project.git
```

## Command Reference

### Core Workflow Commands

| Command | Purpose | Blade Runner Reference |
|---------|---------|------------------------|
| `pris 00-baseline` | Initialize/validate PRIS system | Baseline test - establishing stable state |
| `pris 01-voight-kampff` | Gather requirements | The empathy test for understanding user needs |
| `pris 02-joshi` | Prioritize backlog | Lieutenant Joshi assigning priorities |
| `pris 03-tyrell` | Design architecture | Dr. Tyrell, the original architect |
| `pris 04-sebastian` | Build project structure | J.F. Sebastian, the builder |
| `pris 05-wallace` | Orchestrate multiple agents | Niander Wallace coordinating operations |
| `pris 06-cells` | Decompose epics | "Cells interlinked" - breaking into units |
| `pris 07-construct` | Implement features | Constructing the implementation |
| `pris 08-mesh` | Sync agent states | Agents meshing together |
| `pris 09-stelline` | Create memory handoffs | Ana Stelline, memory designer |
| `pris 10-deckard` | Multi-modal review | Rick Deckard investigating issues |

### Utility Commands

| Command | Purpose | Reference |
|---------|---------|-----------|
| `pris 11-vk` | Quick validation | Shortened Voight-Kampff |
| `pris 12-morehuman` | Improve prompts | "More human than human" |
| `pris 13-tearsInRain` | Migrate versions | Preserving what matters |

## Directory Structure

```
.pris/
├── NEXUS.json          # System configuration
├── inception.log       # Operation log
├── memories/           # Living documents
│   ├── _VK-TEST.md    # Requirements
│   ├── _BACKLOG.md    # Prioritized features
│   ├── _BLUEPRINT.md  # Architecture
│   └── _BASELINE.md   # Issues/tests
└── cells/             # Historical artifacts
    ├── vk-results/    # Requirements artifacts
    ├── blueprints/    # Architecture records
    └── retirements/   # Completed work
```

## Updating PRIS

```bash
# Update PRIS to latest version
cd your-project
git submodule update --remote .pris
git add .pris
git commit -m "Update PRIS to latest version"
```

## Development Philosophy

PRIS embraces the Blade Runner ethos:
- **"More human than human"** - Continuously improving AI assistance
- **"Cells interlinked"** - Modular, connected components
- **"What's real?"** - Building genuine, working software
- **"Tears in rain"** - Preserving knowledge through documentation

## License

MIT License - See LICENSE file for details

---

*"The light that burns twice as bright burns half as long, and you have burned so very, very brightly."*