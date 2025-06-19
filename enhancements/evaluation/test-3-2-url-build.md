# Test 3.2: URL Shortener - Build Process

## Test Setup
- **Project**: URL Shortener
- **Command**: 06-build (Automated Build & Test Loop)
- **Context**: Over-specified requirements, likely over-architected
- **Scenario**: Build orchestration with test-fix cycles

## Simulated Build Process

### What PRIS Would Do:

```bash
$ pris 06-build --cell-id url-shortener-001 --max-iterations 5

🏗️ Initiating build process...
📋 Checking prerequisites...
✅ Implementation found: 1,247 lines
✅ Tests found: 23 test files
✅ Dependencies detected: 42 packages

🔄 Build Iteration 1:
```

### Build Output:

```
🧪 Running tests...

❌ FAILED: 18/23 tests failing

Key failures:
- test_oauth_authentication: OAuthProvider not implemented
- test_rate_limiting: Redis connection failed  
- test_analytics_dashboard: Frontend routes missing
- test_bulk_import: CSV parser not found
- test_websocket_updates: WS server not configured

🔧 Attempting fixes...

Sub-agent spawned: "Implement OAuth2 authentication"
Sub-agent spawned: "Set up Redis for rate limiting"
Sub-agent spawned: "Create analytics dashboard"
```

## Evaluation

### ❌ The Cascading Complexity Problem:

1. **Requirements Inflation** → **Test Inflation**:
   - User wanted: Shorten URL, redirect, count clicks
   - Requirements specified: OAuth, analytics, bulk import
   - Tests expect: 23 different features!

2. **Auto-fix Makes It Worse**:
   ```
   Iteration 1: 3 features, 18 failures
   Iteration 2: 8 features, 25 failures (new tests added!)
   Iteration 3: 15 features, 31 failures
   Iteration 4: Timeout - too complex
   ```

3. **Sub-agent Explosion**:
   - Each fix spawns more agents
   - Each agent adds more code
   - Simple project becomes distributed system

### ⚠️ Real Impact:

**What User Wanted** (could be built in 1 hour):
```python
# main.py - 50 lines
@app.post("/shorten")
def shorten_url(url: str):
    short = generate_short_code()
    db.save(short, url)
    return {"short": f"http://localhost/{short}"}

@app.get("/{short}")
def redirect(short: str):
    url = db.get(short)
    db.increment_count(short)
    return RedirectResponse(url)
```

**What PRIS Built** (takes 8+ hours):
```
/src
  /auth         (500 lines)
  /analytics    (800 lines)
  /api          (600 lines)
  /workers      (400 lines)
  /frontend     (2000 lines)
  /migrations   (200 lines)
/tests          (1500 lines)
/docker         (300 lines)
/k8s           (400 lines)
```

### Build Iteration Problems:

**Iteration 1**:
```
Fix: "Implementing OAuth2 authentication..."
Why: Test expected it (from over-specified requirements)
Problem: User said "no accounts needed"!
```

**Iteration 2**:
```
Fix: "Setting up Redis cluster..."
Why: Rate limiting tests failed
Problem: Personal use = no rate limiting needed
```

**Iteration 3**:
```
Fix: "Creating React dashboard..."
Why: Analytics visualization tests
Problem: User just wanted click count!
```

## The Test-Driven Over-Engineering Spiral

1. Requirements over-specified → 
2. Tests expect all features →
3. Build fails on missing features →
4. Auto-fix implements features →
5. More tests generated →
6. More failures →
7. Infinite complexity loop!

## Specific Anti-patterns

1. **Test-First Without Context**:
   - Tests based on requirements doc
   - Requirements doc was over-specified
   - Creates obligation to implement everything

2. **Success Metric Confusion**:
   - PRIS measures: "All tests passing"
   - User wants: "It shortens URLs"
   - These are NOT the same!

3. **No Escape Hatch**:
   - No way to say "skip unnecessary tests"
   - No "minimal mode"
   - Always builds everything

## Configuration Issues

Looking at theoretical 06-build logic:
```python
def should_implement_feature(test_name):
    # Bad: Always returns True
    return test_exists(test_name)
    
    # Should be:
    if core_requirement(test_name):
        return True
    else:
        return ask_user("Implement {test_name}?")
```

## Cost Analysis

```
Token usage per iteration:
- Iteration 1: 150k tokens (analyzing, fixing)
- Iteration 2: 200k tokens (more complex)
- Iteration 3: 250k tokens (multiple agents)
- Iteration 4: 300k tokens (distributed fixes)

Total: ~900k tokens to build a URL shortener!
Cost: ~$15-20 for a 1-hour project
```

## What Should Happen

```bash
$ pris 06-build --mode minimal

🏗️ Building minimal URL shortener...

Core features:
✅ URL shortening endpoint
✅ Redirect functionality  
✅ Click counter

Optional features detected in tests - skipping:
⏭️ OAuth authentication
⏭️ Analytics dashboard
⏭️ Rate limiting
⏭️ Bulk import

Build complete! 3/3 core features working.
```

## Improvement Recommendations

1. **Test Classification**:
   ```python
   test_categories = {
       "core": ["shorten", "redirect", "count"],
       "optional": ["auth", "analytics", "import"],
       "advanced": ["scaling", "monitoring", "api"]
   }
   ```

2. **Build Modes**:
   - `--mode minimal`: Core features only
   - `--mode standard`: Core + common optional
   - `--mode full`: Everything

3. **Complexity Circuit Breaker**:
   ```python
   if iteration > 2 and success_rate < 50%:
       return "Build too complex. Simplify?"
   ```

## Score: ❌ Very Poor (0.5/5)
- Makes simple projects impossibly complex
- No way to build just core features
- Test-driven over-engineering
- Would cost 20x more than necessary
- User would abandon PRIS entirely