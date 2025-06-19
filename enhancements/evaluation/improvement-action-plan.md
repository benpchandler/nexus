# PRIS Improvement Action Plan

*Based on comprehensive testing of 3 projects across 9 commands*

## Critical Issue: Systematic Over-Engineering

PRIS treats every project as enterprise-scale, resulting in:
- 50-line projects becoming 5000+ lines
- Simple learning projects getting OAuth, Redis, Kubernetes
- Token costs 10-20x higher than necessary
- Users abandoning the tool

## Immediate Actions (Do This Week)

### 1. Add Simplicity Detection
Create `/lib/complexity-detector.py`:
```python
def detect_project_complexity(description, requirements):
    """Returns: 'minimal', 'simple', 'standard', 'complex'"""
    
    minimal_indicators = [
        "just", "simple", "basic", "learning",
        "personal", "quick", "minimal", "practice"
    ]
    
    if any(word in description.lower() for word in minimal_indicators):
        return "minimal"
    
    if requirements.get("users", 0) < 10:
        return "simple"
    
    return "standard"
```

### 2. Modify All Commands to Use Complexity

Update each command's initial analysis:
```python
# In every command file:
complexity = detect_project_complexity(user_input, context)

if complexity == "minimal":
    self.use_minimal_patterns()
    self.skip_advanced_features()
    self.limit_blade_runner_refs(max=1)
```

### 3. Create Minimal Pattern Set

Add to `.pris/patterns/minimal/`:
```markdown
# minimal-crud.pattern.md
complexity: minimal
lines: 50
dependencies: none

## When to use
- Learning projects
- Personal tools
- Quick prototypes

## Implementation
@app.get("/items")
def list_items():
    return db.get_all()

@app.post("/items")  
def create_item(item: Item):
    return db.save(item)
```

### 4. Fix Test Generation

Update `05-verify.md` to categorize tests:
```python
def categorize_tests(tests, project_complexity):
    if project_complexity == "minimal":
        return {
            "run": tests.filter(category="core"),
            "skip": tests.filter(category="advanced"),
            "suggest": tests.filter(category="optional")
        }
```

## Short-term Improvements (Next 2 Weeks)

### 1. Progressive Architecture Selection

Update `03-tyrell.md`:
```python
architecture_progression = {
    "minimal": {
        "weather_app": "HTML + fetch()",
        "task_api": "FastAPI minimal",
        "url_shortener": "Single file Flask"
    },
    "simple": {
        "weather_app": "React + fetch()",
        "task_api": "FastAPI + SQLite",
        "url_shortener": "Flask + PostgreSQL"
    },
    "standard": {
        # Current PRIS suggestions
    }
}
```

### 2. Build Mode Selection

Update `06-build.md`:
```bash
$ pris 06-build --mode [minimal|simple|standard|full]

# Auto-detect if not specified:
mode = args.mode or detect_appropriate_mode(project)
```

### 3. Sub-Agent Complexity Limits

Update `14-spawn.md`:
```python
def should_spawn_agents(task, complexity):
    if complexity == "minimal":
        return False  # Single agent only
    
    if complexity == "simple" and estimated_loc < 500:
        return False  # Still too simple
        
    return True  # Current behavior
```

### 4. Cost Estimation

Add to all commands:
```python
def estimate_cost(complexity, features):
    token_estimates = {
        "minimal": 10_000,    # ~$0.15
        "simple": 50_000,     # ~$0.75
        "standard": 200_000,  # ~$3.00
        "complex": 500_000    # ~$7.50
    }
    
    return f"Estimated cost: ${token_estimates[complexity] * 0.000015:.2f}"
```

## Medium-term Changes (Next Month)

### 1. Rebuild Pattern Library Structure

```
.pris/patterns/
├── minimal/          # < 100 lines
│   ├── hello-world/
│   ├── simple-crud/
│   └── basic-auth/
├── learning/         # 100-500 lines
│   ├── todo-app/
│   ├── blog-api/
│   └── auth-system/
├── standard/         # 500-2000 lines
│   └── [current patterns]
└── enterprise/       # 2000+ lines
    └── [complex patterns]
```

### 2. Interactive Complexity Confirmation

```
PRIS: "I noticed this seems like a learning project. Would you prefer:
1. Minimal implementation (fastest to build, easiest to understand)
2. Standard implementation (production patterns, more features)
3. Let me decide based on requirements

Choice [1]: _"
```

### 3. Pattern Inheritance System

```yaml
# patterns/minimal/todo-api.yaml
name: Minimal Todo API
extends: null
features: [create, read]

# patterns/learning/todo-api-with-update.yaml  
name: Todo API with Updates
extends: minimal/todo-api
adds: [update, delete]

# patterns/standard/todo-api-full.yaml
name: Full Todo API
extends: learning/todo-api-with-update
adds: [auth, pagination, search]
```

### 4. Feedback Collection

```python
# After project completion:
def collect_feedback():
    print("\nQuick feedback (helps improve PRIS):")
    print("1. Too simple")
    print("2. Just right")  
    print("3. Too complex")
    
    # Store in .pris/feedback/
    # Use to adjust future suggestions
```

## Long-term Vision (Next Quarter)

### 1. Machine Learning from Feedback
- Track which patterns succeed/fail
- Learn appropriate complexity for different users
- Adjust suggestions based on history

### 2. Community Pattern Repository
- Allow sharing of simple patterns
- Upvote/downvote system
- Verified "learning-friendly" tag

### 3. Progressive Enhancement Workflow
```
$ pris enhance --from minimal --to simple
"I'll add authentication to your existing todo API..."
```

### 4. Educational Mode
```
$ pris learn --topic "REST APIs"
"Let's build a minimal example to understand REST principles..."
```

## Configuration Changes

Add to `.pris/config.yaml`:
```yaml
defaults:
  complexity: "auto"  # auto-detect from context
  blade_runner_refs: 1  # max per session
  pattern_matching: "progressive"  # start simple
  test_mode: "core_first"  # only test essentials
  
overrides:
  learning_mode: true  # prefer simple solutions
  cost_warnings: true  # warn if > $1 estimated
  
experimental:
  simplicity_scoring: true
  pattern_inheritance: true
  feedback_learning: true
```

## Success Criteria

After implementing these changes:

1. **Simple projects remain simple**
   - URL shortener: ~100 lines (not 5000)
   - Weather dashboard: ~300 lines (not 3000)
   - Task API: ~200 lines (not 2000)

2. **Costs drop dramatically**
   - Simple project: < $0.50 (not $15)
   - Learning project: < $1 (not $20)

3. **User satisfaction improves**
   - Beginners can actually use PRIS
   - Projects match expectations
   - Clear progression path

4. **Professional features still available**
   - Complex projects still get enterprise features
   - But only when actually needed
   - User explicitly chooses complexity

## Final Recommendation

**Most Important Change**: Before implementing ANY other enhancement, add complexity detection and use it to adjust ALL behaviors. This single change would prevent 80% of the issues found in testing.

PRIS is powerful but needs guardrails to prevent over-engineering simple projects. Start simple, scale when needed.