# Example NEXUS Hook Implementations

This document provides concrete examples of Claude Code Hooks that enhance NEXUS workflows.

## 1. Documentation Index Auto-Update Hook

**Purpose**: Automatically update documentation indices when files are created or modified in .nexus/ directories.

**Hook Type**: PostToolUse  
**Trigger**: Write, Edit, MultiEdit operations

### Configuration
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.nexus/hooks/update-documentation-index.sh"
          }
        ]
      }
    ]
  }
}
```

### Implementation
```bash
#!/bin/bash
# NEXUS Hook: Documentation Index Auto-Update
# Purpose: Update .nexus/memories/_DOCUMENTATION.md when files change
# Trigger: After file write/edit operations

# Parse JSON input
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Check if this is a NEXUS project and file is in .nexus/
if [[ -d ".nexus" && "$file_path" == *".nexus/"* ]]; then
    # Extract file type and update appropriate index
    if [[ "$file_path" == *"_30-ARCHITECTURE.md" ]]; then
        echo "## Architecture Decisions (ADRs)" >> .nexus/memories/_DOCUMENTATION.md
        echo "- Architecture Decision | $file_path | Updated | $(date)" >> .nexus/memories/_DOCUMENTATION.md
    elif [[ "$file_path" == *"ADR-"* ]]; then
        echo "- $(basename "$file_path" .md) | $file_path | Created | $(date)" >> .nexus/memories/_DOCUMENTATION.md
    fi
    
    echo "📝 Updated documentation index for $file_path"
fi
```

## 2. NEXUS Command Sequence Validation Hook

**Purpose**: Ensure NEXUS commands are executed in proper sequence with required prerequisites.

**Hook Type**: PreToolUse  
**Trigger**: Before any tool execution

### Configuration
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.nexus/hooks/validate-command-sequence.py"
          }
        ]
      }
    ]
  }
}
```

### Implementation
```python
#!/usr/bin/env python3
"""
NEXUS Hook: Command Sequence Validation
Purpose: Validate NEXUS command prerequisites and sequence
Trigger: Before any tool execution
"""

import json
import sys
import os
import re
from pathlib import Path

# NEXUS command dependencies
COMMAND_DEPENDENCIES = {
    "04-scaffold": ["03-architect"],
    "05-construct": ["04-scaffold"],
    "06-verify": ["05-construct"],
    "07-refine": ["06-verify"]
}

def is_nexus_project():
    return os.path.exists(".nexus")

def get_nexus_command_from_input(tool_input):
    """Extract NEXUS command from tool input if present"""
    if isinstance(tool_input, dict):
        content = tool_input.get('content', '')
        # Look for NEXUS command patterns
        match = re.search(r'(\d{2}-\w+)', content)
        if match:
            return match.group(1)
    return None

def check_prerequisites(command):
    """Check if prerequisites for a command are met"""
    if command not in COMMAND_DEPENDENCIES:
        return True, ""
    
    required_commands = COMMAND_DEPENDENCIES[command]
    missing = []
    
    for req_cmd in required_commands:
        # Check if required files exist
        if req_cmd == "03-architect":
            if not os.path.exists(".nexus/memories/_30-ARCHITECTURE.md"):
                missing.append(f"Architecture decision from {req_cmd}")
        elif req_cmd == "04-scaffold":
            if not os.path.exists("package.json") and not os.path.exists("requirements.txt"):
                missing.append(f"Project setup from {req_cmd}")
    
    if missing:
        return False, f"Missing prerequisites: {', '.join(missing)}"
    
    return True, ""

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # Not JSON input, allow to proceed
    
    if not is_nexus_project():
        sys.exit(0)  # Not a NEXUS project, allow to proceed
    
    tool_input = input_data.get('tool_input', {})
    nexus_command = get_nexus_command_from_input(tool_input)
    
    if nexus_command:
        valid, error_msg = check_prerequisites(nexus_command)
        if not valid:
            print(f"❌ NEXUS Workflow Error: {error_msg}", file=sys.stderr)
            print(f"Please complete the prerequisite steps before running {nexus_command}", file=sys.stderr)
            sys.exit(2)  # Block the operation
        else:
            print(f"✅ NEXUS prerequisites validated for {nexus_command}")
    
    sys.exit(0)  # Allow operation to proceed

if __name__ == "__main__":
    main()
```

## 3. Simplicity Mode Enforcement Hook

**Purpose**: Enforce simplicity mode constraints when detected in project requirements.

**Hook Type**: PreToolUse  
**Trigger**: Before file writes that might violate simplicity mode

### Configuration
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.nexus/hooks/enforce-simplicity-mode.py"
          }
        ]
      }
    ]
  }
}
```

### Implementation
```python
#!/usr/bin/env python3
"""
NEXUS Hook: Simplicity Mode Enforcement
Purpose: Validate that code follows simplicity mode constraints
Trigger: Before file write operations
"""

import json
import sys
import os
import re

# Patterns that violate simplicity mode
COMPLEXITY_PATTERNS = [
    (r'import.*kubernetes', 'Kubernetes is too complex for simplicity mode'),
    (r'import.*docker', 'Docker containers violate simplicity mode'),
    (r'class.*Factory|Builder|Strategy', 'Design patterns are too complex for simplicity mode'),
    (r'@.*decorator', 'Complex decorators should be avoided in simplicity mode'),
    (r'async.*await', 'Async patterns may be too complex - consider simpler alternatives'),
]

def is_simplicity_mode():
    """Check if project is in simplicity mode"""
    if not os.path.exists(".nexus/memories/_10-REQUIREMENTS.md"):
        return False
    
    with open(".nexus/memories/_10-REQUIREMENTS.md", 'r') as f:
        content = f.read()
        return "SIMPLICITY MODE" in content.upper()

def check_content_complexity(content, file_path):
    """Check if content violates simplicity mode"""
    violations = []
    
    for pattern, message in COMPLEXITY_PATTERNS:
        if re.search(pattern, content, re.IGNORECASE):
            violations.append(f"Line with '{pattern}': {message}")
    
    # Check file structure complexity
    if file_path.endswith('.py'):
        lines = content.split('\n')
        if len(lines) > 200:
            violations.append("File is too long (>200 lines) for simplicity mode")
    
    return violations

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)
    
    if not is_simplicity_mode():
        sys.exit(0)  # Not in simplicity mode, allow to proceed
    
    tool_input = input_data.get('tool_input', {})
    file_path = tool_input.get('file_path', '')
    content = tool_input.get('content', '')
    
    if not content or not file_path:
        sys.exit(0)  # No content to check
    
    violations = check_content_complexity(content, file_path)
    
    if violations:
        print("❌ SIMPLICITY MODE VIOLATION:", file=sys.stderr)
        for violation in violations:
            print(f"  • {violation}", file=sys.stderr)
        print("\nSuggestion: Simplify the implementation or disable simplicity mode if complexity is required.", file=sys.stderr)
        sys.exit(2)  # Block the operation
    
    print("✅ Content complies with simplicity mode constraints")
    sys.exit(0)

if __name__ == "__main__":
    main()
```

## 4. Version Research Automation Hook

**Purpose**: Automatically trigger version research when dependencies are modified.

**Hook Type**: PostToolUse  
**Trigger**: After modifying package.json, requirements.txt, or similar files

### Configuration
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.nexus/hooks/auto-version-research.sh"
          }
        ]
      }
    ]
  }
}
```

### Implementation
```bash
#!/bin/bash
# NEXUS Hook: Auto Version Research
# Purpose: Trigger version research when dependency files change
# Trigger: After file write/edit operations

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Check if this is a dependency file
if [[ "$file_path" =~ (package\.json|requirements\.txt|Cargo\.toml|go\.mod|composer\.json)$ ]]; then
    if [[ -d ".nexus" ]]; then
        echo "🔍 Dependency file updated: $file_path"
        echo "Triggering version research..."
        
        # Create a version research task
        timestamp=$(date +"%Y%m%d_%H%M%S")
        research_file=".nexus/history/30-blueprints/025-VERSION-RESEARCH-${timestamp}.md"
        
        cat > "$research_file" << EOF
# Version Research - $(date)

## Trigger
Dependency file updated: $file_path

## Action Required
Run version research to validate:
1. Latest stable versions of modified dependencies
2. Compatibility between components
3. Security advisories for new versions
4. LTS availability

## Next Steps
- [ ] Review changes in $file_path
- [ ] Research latest versions
- [ ] Update architecture documentation if needed
- [ ] Validate compatibility matrix
EOF
        
        echo "📝 Created version research task: $research_file"
        echo "💡 Consider running the 03-architect command to update version research"
    fi
fi
```

## 5. Project State Tracking Hook

**Purpose**: Track NEXUS command completion and project state.

**Hook Type**: Stop  
**Trigger**: When Claude Code session ends

### Configuration
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.nexus/hooks/track-project-state.py"
          }
        ]
      }
    ]
  }
}
```

### Implementation
```python
#!/usr/bin/env python3
"""
NEXUS Hook: Project State Tracking
Purpose: Track completed NEXUS commands and project state
Trigger: When Claude Code session ends
"""

import json
import sys
import os
from datetime import datetime
from pathlib import Path

def is_nexus_project():
    return os.path.exists(".nexus")

def get_completed_commands():
    """Analyze project to determine completed NEXUS commands"""
    completed = []
    
    # Check for architecture decision
    if os.path.exists(".nexus/memories/_30-ARCHITECTURE.md"):
        completed.append("03-architect")
    
    # Check for project setup
    if any(os.path.exists(f) for f in ["package.json", "requirements.txt", "Cargo.toml"]):
        completed.append("04-scaffold")
    
    # Check for implementation
    src_dirs = ["src", "app", "lib", "components"]
    if any(os.path.exists(d) for d in src_dirs):
        completed.append("05-construct")
    
    # Check for tests
    test_dirs = ["test", "tests", "__tests__", "spec"]
    if any(os.path.exists(d) for d in test_dirs):
        completed.append("06-verify")
    
    return completed

def update_project_state():
    """Update project state file"""
    if not is_nexus_project():
        return
    
    state_dir = Path(".nexus/10_STATE_OF_PROJECT")
    state_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    state_file = state_dir / f"project-state-{timestamp}.md"
    
    completed_commands = get_completed_commands()
    
    with open(state_file, 'w') as f:
        f.write(f"# Project State - {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
        f.write("## Completed NEXUS Commands\n")
        for cmd in completed_commands:
            f.write(f"- [x] {cmd}\n")
        
        f.write("\n## Project Structure\n")
        for item in os.listdir("."):
            if os.path.isdir(item) and not item.startswith("."):
                f.write(f"- 📁 {item}/\n")
        
        f.write("\n## Next Suggested Actions\n")
        if "03-architect" not in completed_commands:
            f.write("- [ ] Run 03-architect to define system architecture\n")
        elif "04-scaffold" not in completed_commands:
            f.write("- [ ] Run 04-scaffold to set up project structure\n")
        elif "05-construct" not in completed_commands:
            f.write("- [ ] Run 05-construct to implement features\n")
        elif "06-verify" not in completed_commands:
            f.write("- [ ] Run 06-verify to add tests and validation\n")
        else:
            f.write("- [ ] Consider 07-refine for optimization and polish\n")
    
    print(f"📊 Updated project state: {state_file}")

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        pass  # No JSON input expected for Stop hooks
    
    update_project_state()
    sys.exit(0)

if __name__ == "__main__":
    main()
```

## Installation and Usage

### 1. Create Hook Directory Structure
```bash
mkdir -p ~/.nexus/hooks/lib
chmod +x ~/.nexus/hooks/*.sh ~/.nexus/hooks/*.py
```

### 2. Install Hooks
Copy the hook scripts to `~/.nexus/hooks/` and make them executable.

### 3. Configure Claude Code
Add the hook configurations to your `.claude/settings.json` file.

### 4. Test Hooks
Run Claude Code in a NEXUS project and observe the hook behavior.

## Benefits

- **Automated Documentation**: Keeps .nexus/ files synchronized
- **Workflow Validation**: Prevents common sequence errors
- **Quality Assurance**: Enforces project standards automatically
- **State Tracking**: Maintains clear project progress visibility
- **Simplicity Enforcement**: Ensures appropriate complexity levels

These hooks demonstrate how Claude Code Hooks can enhance NEXUS workflows while maintaining the system's flexibility and human oversight principles.
