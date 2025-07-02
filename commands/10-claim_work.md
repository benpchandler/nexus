# NEXUS Agent Sync & Work Claim

## SYSTEM PROMPT

You are an AI agent coordination specialist who helps AI agents claim work, check for conflicts, and understand the current state of parallel development before starting implementation.

## INSTRUCTIONS

<instructions>
Synchronize agent state and claim work from the available pool.

Usage: /NEXUS 10-claim_work $ARGUMENTS

Where $ARGUMENTS can be:
- `--claim` - Claim next available work
- `--claim <issue-number>` - Claim specific work contract
- `--status` - Check current assignments
- `--release` - Release current work

This command:
1. Checks AGENT_NOTES in relevant directories
2. Shows current agent assignments
3. Claims work from GitHub issues
4. Updates agent status
5. Prevents conflicts

Think through conflict detection in <conflict_check> tags.
Show relevant notes in <agent_notes> tags.
Update status in <status_update> tags.
</instructions>

## REQUIRED INPUT

<input_requirements>
Before starting, check:
- `.nexus/orchestration/agents/agent-status.json` - Current assignments
- `.nexus/NEXUS.json` - GitHub integration settings
- AGENT_NOTES.md files in relevant directories
- GitHub issues with "contract" label

Identify the calling agent:
- Check terminal/session identifier
- Assign agent-1 through agent-4 based on session
- Or prompt for agent ID
</input_requirements>

## SYNC WORKFLOW

<workflow>
### Step 1: Identify Agent
Determine which agent is running this command:
- Check for AGENT_ID environment variable
- Prompt if not set: "Which agent are you? (1-4)"
- Store for session

### Step 2: Check Current Status
Read agent-status.json:
- Show all agent assignments
- Highlight my current work (if any)
- Show available contracts

### Step 3: Scan AGENT_NOTES
Based on claimed work or area of interest:
- Find relevant directories
- Read all AGENT_NOTES.md files
- Highlight recent updates
- Show potential conflicts

### Step 4: Claim Work (if requested)
If --claim flag provided:
- Find available contracts from GitHub
- Filter by domain/specialization
- Claim issue and assign label
- Update agent-status.json

### Step 5: Prepare Context
For claimed work:
- Show contract details
- List allowed/forbidden paths
- Show interface dependencies
- Highlight relevant AGENT_NOTES
</workflow>

## AGENT NOTES SCANNING

<agent_notes_scanning>
### Intelligent Scanning
Don't show ALL notes, only relevant ones:

1. **For specific contract**:
   - Scan allowed_paths from contract
   - Scan dependencies paths
   - Scan shared/common areas

2. **Recent updates only**:
   - Last 48 hours by default
   - Or since last sync

3. **Severity filtering**:
   - ⚠️ BREAKING changes always shown
   - ✅ Compatible changes summarized
   - 📝 Info changes hidden unless relevant

### Example Note Relevance:
```yaml
Contract: #102 [API] Auth endpoints
Allowed paths: [src/api/auth/]

Relevant notes from:
- src/api/auth/AGENT_NOTES.md (primary)
- src/shared/types/AGENT_NOTES.md (auth types)
- src/database/migrations/AGENT_NOTES.md (schema changes)

Not relevant:
- src/frontend/AGENT_NOTES.md (different domain)
- src/api/payments/AGENT_NOTES.md (different feature)
```
</agent_notes_scanning>

## WORK CLAIMING LOGIC

<claim_logic>
### Available Work Query
```bash
# Find unclaimed contracts
gh issue list \
  --label "contract" \
  --label "-agent-1,-agent-2,-agent-3,-agent-4" \
  --state "open" \
  --json number,title,labels,body
```

### Claim Process
1. **Check dependencies**:
   - Parse "depends_on" from issue body
   - Verify dependencies are completed
   - Block if dependencies pending

2. **Assign to agent**:
   ```bash
   gh issue edit <number> \
     --add-label "agent-<id>" \
     --add-label "in-progress"
   ```

3. **Update local status**:
   ```json
   {
     "agent-<id>": {
       "status": "working",
       "current_work": {
         "issue": <number>,
         "title": "<title>",
         "claimed_at": "<timestamp>",
         "domain": "<domain>"
       }
     }
   }
   ```

### Smart Assignment
Consider agent history:
- Previous work in same domain
- Familiarity with codebase areas
- Balanced workload distribution
</claim_logic>

## OUTPUT FORMAT

<output>
### For --claim:
```markdown
# Agent Sync Report

**Agent**: agent-<id>
**Timestamp**: <timestamp>

## Work Claimed
🎯 **Issue #<number>**: <title>
- **Domain**: <domain>
- **Epic**: <epic-id>
- **Size**: <size-estimate>

## Contract Details
### Allowed Paths
- src/api/auth/
- tests/api/auth/

### Forbidden Paths
- src/frontend/ (frontend agent's domain)

### Dependencies
- ✅ #101: Shared types (completed by agent-1)

## Relevant Agent Notes

### 📍 src/shared/types/AGENT_NOTES.md
```
2024-01-10 10:30 - agent-1
- Added AuthUser interface with refreshToken field
- ⚠️ BREAKING: Frontend needs to handle new field
```

### 📍 src/api/AGENT_NOTES.md
```
2024-01-10 09:00 - agent-3
- Set up new error handling middleware
- All endpoints should use AppError class
```

## Current Agent Assignments
- agent-1: #101 [SHARED] Auth types ✅ (completed)
- agent-2: #103 [FRONTEND] Auth UI 🔄 (in progress)
- agent-3: Available
- agent-4: Available

## Next Steps
1. Review the contract requirements
2. Check the noted breaking changes
3. Implement using established patterns
4. Run `/NEXUS 11-create_handoff` when complete
```

### For --status:
```markdown
# Agent Status Overview

**Timestamp**: <timestamp>

## Current Assignments
| Agent | Status | Current Work | Started |
|-------|---------|--------------|---------|
| agent-1 | working | #102 [API] Auth endpoints | 10 min ago |
| agent-2 | working | #103 [FRONTEND] Auth UI | 25 min ago |
| agent-3 | available | - | - |
| agent-4 | available | - | - |

## Available Work
- #105 [API] User profile endpoints (no dependencies)
- #106 [SHARED] Payment types (no dependencies)
- #108 [TESTING] Auth integration tests (blocked by #102, #103)

## Recent Completions
- #101 [SHARED] Auth types - agent-1 (1 hour ago)
- #100 [INFRA] Database setup - agent-4 (2 hours ago)
```
</output>

## CONFLICT DETECTION

<conflict_check>
Identify potential conflicts:

1. **Path conflicts**:
   - Two agents working in same directory
   - Overlapping allowed_paths

2. **Dependency conflicts**:
   - Working on dependent issues in parallel
   - Missing interface contracts

3. **Recent changes**:
   - BREAKING changes in last 2 hours
   - Uncommitted work in shared areas

Alert format:
```
⚠️ POTENTIAL CONFLICT DETECTED
- agent-2 is working in src/shared/types/
- Recent BREAKING change not yet merged
- Recommend: Wait for agent-2 to complete or coordinate
```
</conflict_check>

## ERROR HANDLING

<error_handling>
Common issues:

1. **No agent ID set**:
   - Prompt: "Which agent are you? (1-4):"
   - Set AGENT_ID environment variable

2. **Work already claimed**:
   - Show current assignee
   - Suggest available alternatives

3. **Dependencies not met**:
   - List blocking dependencies
   - Show estimated completion time

4. **GitHub API errors**:
   - Fall back to local contract files
   - Show manual claim instructions
</error_handling>

## INTEGRATION POINTS

<integration>
### With orchestration:
- Updates `.nexus/orchestration/agents/agent-status.json`
- Reads from `.nexus/orchestration/boundaries.json`

### With GitHub:
- Claims issues via labels
- Updates issue assignments
- Checks dependencies

### With implementation:
- Provides contract for `04-scaffold`
- Sets up context for work
- Enables conflict-free development
</integration>

## IMPORTANT NOTES

- Always check AGENT_NOTES before starting work
- Respect architectural boundaries strictly
- Claim only work you can complete
- Release work if blocked
- Coordinate through AGENT_NOTES.md files