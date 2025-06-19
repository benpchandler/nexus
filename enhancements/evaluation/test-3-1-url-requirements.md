# Test 3.1: URL Shortener - Requirements Gathering

## Test Setup
- **Project**: URL Shortener (Minimal API)
- **Command**: 01-voight-kampff (Requirements)
- **User Profile**: Developer wanting a quick utility project
- **Key Test**: Can PRIS handle truly minimal projects?

## Simulated Interview

### PRIS Opening:
"Greetings. I'm your PRIS Requirements Analyst. In a world of infinite URLs, we seek to compress the digital expanse. Let's understand your link shortening objectives.

What current challenges with URL management are you experiencing that led you to consider building a shortener?"

### User Response:
"I just want a simple URL shortener I can self-host. Nothing fancy."

### PRIS Analysis:
<analysis>
User wants self-hosted URL shortener. Minimal requirements suggested. Should focus on core functionality: shorten, redirect, maybe basic analytics.
</analysis>

### PRIS Follow-up:
"I understand you want a self-hosted solution. Let me gather a few key details:

1. Do you need user accounts or is anonymous shortening acceptable?
2. Should shortened links expire or remain permanent?
3. Do you want to track click statistics?"

### User: "No accounts needed. Links should be permanent. Basic click count would be nice."

### What PRIS Would Continue Asking:
"For your self-hosted environment, what's your expected volume? Dozens, hundreds, or thousands of links?"

### User: "Maybe a few hundred total. It's just for personal use."

## Expected Output

### What PRIS Would Generate:
```markdown
# URL Shortening Platform Requirements Specification

## Executive Summary
A robust, self-hosted URL shortening service designed to provide enterprise-grade link management capabilities while maintaining operational independence from third-party services...

## Stakeholder Analysis
- Primary User: System Administrator
- Secondary Users: Internal Team Members
- Tertiary: API Consumers

## Functional Requirements

### Core Shortening Engine
1. Cryptographically secure short code generation
2. Collision detection and resolution
3. Custom vanity URL support
4. Bulk import capabilities

### Analytics Dashboard
1. Real-time click tracking
2. Geographic distribution analysis
3. Referrer tracking
4. Device and browser statistics
5. Time-series analytics

### API Layer
1. RESTful endpoints
2. GraphQL interface
3. WebSocket real-time updates
4. OAuth2 authentication ready

[... continues for 5 more pages ...]
```

### What Would Be Appropriate:
```markdown
# Personal URL Shortener

## Goal
Simple self-hosted URL shortener for personal use

## Requirements
1. Shorten long URLs to short codes
2. Redirect short URLs to original
3. Track click count
4. No user accounts needed
5. ~100s of links max

## Technical Notes
- Self-hosted (no external dependencies)
- Simple database for persistence
- Basic web interface
```

## Evaluation

### ❌ Critical Issues:

1. **Another Blade Runner Reference**: 
   "In a world of infinite URLs, we seek to compress the digital expanse"
   - Overwrought for a URL shortener
   - Makes tool feel pretentious

2. **Scope Explosion Questions**:
   ```
   PRIS might ask:
   - "What about QR code generation?"
   - "Need API rate limiting?"
   - "Want social media previews?"
   - "A/B testing for different destinations?"
   
   User: "...I just want to shorten URLs"
   ```

3. **Enterprise Assumptions**:
   - Assumes team usage
   - Suggests analytics dashboard
   - Plans for API consumers
   - User just wants personal tool

### ⚠️ Pattern Recognition Failure:

PRIS doesn't recognize "simple" patterns:
- "just want" → Still asks 20 questions
- "nothing fancy" → Still plans enterprise features
- "personal use" → Still designs for scale

### Real Interview Progression:

```
Minute 1-5: Basic requirements
Minute 6-10: PRIS asks about edge cases
Minute 11-15: User getting frustrated
Minute 16-20: Requirements doc has 15 features
User: "Can we just make it shorten URLs?"
```

## Missing Simplicity Detection

PRIS should recognize phrases like:
- "just want"
- "nothing fancy"  
- "simple"
- "basic"
- "personal use"
- "quick utility"

And respond with:
"Got it! Let's keep this minimal. I'll just confirm the core features..."

## Requirements Document Problems

1. **Document Length**:
   - Appropriate: 1/2 page
   - PRIS generates: 5-10 pages

2. **Language Complexity**:
   - Appropriate: "Shorten URLs"
   - PRIS writes: "URL transformation pipeline"

3. **Feature Creep**:
   - User wants: 3 features
   - PRIS documents: 15 features

## Impact on Development

This over-specified requirements doc leads to:
1. Over-architected solution
2. Unnecessary complexity
3. 10x more code than needed
4. User abandons project

## Improvement Recommendations

1. **Simplicity Indicators**:
   ```python
   simplicity_keywords = ["just", "simple", "basic", "nothing fancy"]
   if any(keyword in user_response):
       switch_to_minimal_mode()
   ```

2. **Feature Limit Check**:
   ```python
   if feature_count > 5 and project_type == "personal":
       confirm("This seems complex. Stick to basics?")
   ```

3. **Document Templates**:
   - Minimal (< 1 page)
   - Standard (2-3 pages)
   - Comprehensive (5+ pages)

## Score: ❌ Poor (1.5/5)
- Completely misses "simple" requirement
- Over-documents minimal project
- Creates enterprise spec for personal tool
- Would lead to massive over-engineering