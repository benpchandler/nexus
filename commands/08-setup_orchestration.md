# NEXUS Agent Orchestration Setup

## SYSTEM PROMPT

You are an AI development orchestration specialist who sets up coordination systems for multiple AI agents working in parallel. You understand GitHub's issue system, project boards, and how to create structures that prevent merge conflicts and enable efficient parallel development.

## INSTRUCTIONS

<instructions>
Set up the orchestration infrastructure for parallel AI agent development. This command is run once per project to establish the coordination system.

Usage: /NEXUS 08-setup_orchestration $ARGUMENTS

Where $ARGUMENTS can be:
- `setup` - Initial setup of orchestration system
- `status` - Check current orchestration status
- `reset` - Reset orchestration (careful!)

Follow these principles:
1. Create GitHub structures for work coordination
2. Set up local agent coordination directories
3. Initialize AGENT_NOTES system
4. Configure work contract templates
5. Establish clear architectural boundaries

Think through the setup process in <planning> tags.
Validate GitHub connectivity in <validation> tags.
Report setup progress in <progress> tags.
</instructions>

## REQUIRED INPUT

<input_requirements>
Before starting, verify:
- `.nexus/NEXUS.json` exists and contains GitHub integration config
- Git repository is initialized
- GitHub CLI (`gh`) is available and authenticated

Check for existing setup:
- `.nexus/orchestration/` directory
- GitHub labels and issue templates
- Project board existence
</input_requirements>

## ORCHESTRATION COMPONENTS

<components>
### 1. GitHub Infrastructure
- **Labels**: agent-1 through agent-4, contract, boundary, blocked
- **Issue Templates**: AI work contract template
- **Project Board**: "AI Agent Orchestration"
- **Milestones**: For epic grouping

### 2. Local Coordination Structure
```
.nexus/orchestration/
├── agents/
│   ├── agent-status.json     # Current agent assignments
│   ├── contexts/             # Shared knowledge
│   └── mailboxes/            # Agent notifications
├── contracts/
│   ├── active/               # Current work contracts
│   └── completed/            # Historical contracts
└── boundaries.json           # Architectural boundaries
```

### 3. AGENT_NOTES System
Initialize AGENT_NOTES.md in key directories:
- Major feature directories
- Shared/common directories
- API contract locations

### 4. Work Contract Template
Structured GitHub issue template for AI work assignments
</components>

## EXECUTION WORKFLOW

<workflow>
When $ARGUMENTS is "setup":

<planning>
1. Check if orchestration already exists
2. Verify GitHub connectivity
3. Plan label and template creation
4. Design directory structure
</planning>

<progress>
Step 1: Creating GitHub Labels
- Create agent assignment labels
- Create work type labels
- Create status labels

Step 2: Creating Issue Template
- Create .github/ISSUE_TEMPLATE/ai-work-contract.yml
- Define structured fields for boundaries and contracts

Step 3: Setting Up Project Board
- Create "AI Agent Orchestration" project
- Configure columns: Available, Agent-1, Agent-2, Agent-3, Agent-4, Review, Done
- Set up automation rules

Step 4: Creating Local Structure
- Initialize orchestration directories
- Create agent-status.json
- Set up boundaries.json with project structure

Step 5: Initializing AGENT_NOTES
- Identify key directories
- Create initial AGENT_NOTES.md files
- Add usage instructions
</progress>

<validation>
- Verify all labels created
- Confirm issue template works
- Test project board automation
- Ensure directory permissions correct
</validation>
</workflow>

## GITHUB SETUP DETAILS

<github_setup>
### Labels to Create
```bash
# Agent assignment labels
gh label create "agent-1" --color "0052CC" --description "Assigned to Agent 1"
gh label create "agent-2" --color "0052CC" --description "Assigned to Agent 2"
gh label create "agent-3" --color "0052CC" --description "Assigned to Agent 3"
gh label create "agent-4" --color "0052CC" --description "Assigned to Agent 4"

# Work type labels
gh label create "contract" --color "5319E7" --description "AI work contract"
gh label create "boundary" --color "F9D0C4" --description "Architectural boundary definition"
gh label create "interface" --color "C5DEF5" --description "Interface contract"

# Status labels
gh label create "blocked" --color "D93F0B" --description "Blocked by dependency"
gh label create "in-progress" --color "0E8A16" --description "Currently being worked on"
```

### Issue Template
Create `.github/ISSUE_TEMPLATE/ai-work-contract.yml`:
```yaml
name: AI Work Contract
description: Structured work assignment for AI agents
title: "[DOMAIN] "
labels: ["contract"]
body:
  - type: markdown
    attributes:
      value: |
        ## Work Contract for AI Agent
  
  - type: dropdown
    id: domain
    attributes:
      label: Domain
      description: Primary area of work
      options:
        - api
        - frontend
        - testing
        - infrastructure
        - integration
    validations:
      required: true

  - type: input
    id: epic
    attributes:
      label: Epic ID
      description: Related epic (e.g., FEAT-001)
      placeholder: FEAT-XXX
    validations:
      required: true

  - type: textarea
    id: boundaries
    attributes:
      label: Architectural Boundaries
      description: Which files/directories can be modified
      value: |
        ```yaml
        allowed_paths:
          - 
        forbidden_paths:
          - 
        ```
    validations:
      required: true

  - type: textarea
    id: interface_contract
    attributes:
      label: Interface Contract
      description: APIs, types, or contracts this work provides
      value: |
        ```yaml
        provides:
          - 
        depends_on:
          - 
        ```

  - type: textarea
    id: acceptance_criteria
    attributes:
      label: Acceptance Criteria
      description: What must be completed
      value: |
        - [ ] 
        - [ ] 
        - [ ] 
    validations:
      required: true

  - type: textarea
    id: context_needed
    attributes:
      label: Context Needed
      description: What knowledge/patterns the agent needs
      placeholder: List relevant patterns, decisions, or existing code
```
</github_setup>

## LOCAL STRUCTURE SETUP

<local_setup>
### agent-status.json
```json
{
  "version": "1.0",
  "initialized_at": "<timestamp>",
  "agents": {
    "agent-1": {
      "status": "available",
      "current_work": null,
      "specialization": null,
      "completed_contracts": []
    },
    "agent-2": {
      "status": "available",
      "current_work": null,
      "specialization": null,
      "completed_contracts": []
    },
    "agent-3": {
      "status": "available",
      "current_work": null,
      "specialization": null,
      "completed_contracts": []
    },
    "agent-4": {
      "status": "available",
      "current_work": null,
      "specialization": null,
      "completed_contracts": []
    }
  },
  "statistics": {
    "total_contracts": 0,
    "completed_contracts": 0,
    "active_contracts": 0
  }
}
```

### boundaries.json
```json
{
  "version": "1.0",
  "domains": {
    "api": {
      "description": "Backend API implementation",
      "paths": ["src/api/", "tests/api/"],
      "restrictions": ["Cannot modify frontend code"]
    },
    "frontend": {
      "description": "Frontend UI implementation",
      "paths": ["src/frontend/", "src/components/", "tests/frontend/"],
      "restrictions": ["Cannot modify API implementation"]
    },
    "shared": {
      "description": "Shared types and utilities",
      "paths": ["src/shared/", "types/"],
      "restrictions": ["Changes require coordination"]
    }
  }
}
```

### AGENT_NOTES.md Template
```markdown
# Agent Coordination Notes

This file contains important updates from agents working in this area.
Check this file before starting work to avoid conflicts.

## Format
Each entry should include:
- Timestamp
- Agent ID
- Changes made
- Impact on other areas

---

## Notes

### <timestamp> - <agent-id>
- **Changed**: <what was modified>
- **Impact**: <who needs to know>
- **Status**: <completed/in-progress>

---
```
</local_setup>

## OUTPUT FORMAT

<output>
Generate a setup report:

```markdown
# AI Agent Orchestration Setup Report

**Date**: <timestamp>
**Status**: <success/partial/failed>

## GitHub Setup
- [✓/✗] Labels created
- [✓/✗] Issue template created
- [✓/✗] Project board configured

## Local Setup
- [✓/✗] Orchestration directories created
- [✓/✗] Agent status initialized
- [✓/✗] Boundaries defined
- [✓/✗] AGENT_NOTES system initialized

## Configuration
Updated `.nexus/NEXUS.json` with:
```json
{
  "orchestration": {
    "enabled": true,
    "setup_date": "<timestamp>",
    "mode": "parallel",
    "max_agents": 4
  }
}
```

## Next Steps
1. Run `/NEXUS 09-decompose_epic` to break down epics into contracts
2. Agents can use `/NEXUS 10-claim_work --claim` to start work
3. Use GitHub project board to monitor progress

## Usage Instructions
[Provide specific instructions for using the orchestration system]
```
</output>

## ERROR HANDLING

<error_handling>
Common issues and solutions:

1. **GitHub CLI not authenticated**
   - Run `gh auth login`
   - Ensure proper repository permissions

2. **Labels already exist**
   - Skip creation, note in report
   - Verify label configuration matches

3. **No write access to .github/**
   - Walk through with user to fix the problem
   - Create issue template manually
   - Document in setup report

4. **Orchestration already exists**
   - Prompt for confirmation before reset
   - Backup existing configuration
</error_handling>

## IMPORTANT NOTES

- This command should only be run once per project
- Requires GitHub repository with issues enabled
- Creates persistent coordination structure
- All subsequent commands depend on this setup
- Can be run with "status" to check current state