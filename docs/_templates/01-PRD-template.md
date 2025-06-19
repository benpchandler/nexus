# PRD: [Feature Name]

*Note: PRD defines WHAT we're building and WHY. TDD defines HOW we'll build it technically.*

*Use this template for: User-facing features that take multiple sprints. For new products, start with Vision Doc. For small enhancements, use Quick Decision template.*

*Example running throughout: Automated Report Builder*

## Why This Matters
[One paragraph: Paint the picture of who's struggling without this and how their day gets better with it. Make engineers and designers care.]

Example:
Every morning, Sarah exports data from 3 systems, manually combines them in Excel, and spends 45 minutes creating a report her boss glances at for 30 seconds. By Friday, she's made 15 reports and wants to quit. We're giving her those 11 hours back each week.

## Problem → Solution
**Today**: [Current painful reality]  
**Tomorrow**: [Better world we're creating]  
**Impact**: [Time/money/joy saved]

Example:
**Today**: Export CSV → Copy to Excel → VLOOKUP → Format → Email → 45 min  
**Tomorrow**: Click "Generate Report" → Auto-sent to stakeholders → 30 seconds  
**Impact**: 11 hours/week saved per analyst × 200 analysts = 2,200 hours/week

## Success = 
- [ ] Human win: [How user's life improves]
- [ ] Business win: [Metric with target number]
- [ ] Technical win: [Performance/reliability metric]

Example:
- [ ] Human win: Analysts spend time on insights, not Excel
- [ ] Business win: 90% of daily reports automated within 3 months
- [ ] Technical win: Reports generate in <5 seconds, 99.9% uptime

## Requirements (What, not How)

### Must Have (MVP)
[What users absolutely need to solve the core problem]

Example:
- [ ] Connect to our 3 main data sources (Salesforce, MySQL, Sheets)
- [ ] Build reports with drag-and-drop interface
- [ ] Schedule reports to run automatically
- [ ] Email reports to distribution lists

### Should Have (Fast Follow) 
[What makes it truly good vs just functional]

Example:
- [ ] Mobile preview of reports
- [ ] Conditional formatting rules
- [ ] Export to PowerPoint
- [ ] Report templates library

### Nice to Have (Future)
[What would delight power users]

Example:
- [ ] AI-suggested insights
- [ ] Real-time collaboration
- [ ] Custom SQL queries
- [ ] Webhook integrations

## Critical User Flows

### Flow 1: [Name]
[Step-by-step what user does and what they expect]

Example - Build First Report:
1. User connects data source (one-time OAuth)
2. Sees available fields from all sources in sidebar
3. Drags fields onto canvas 
4. Sees live preview update as they build
5. Clicks "Save & Schedule"
6. Sets recipients and frequency
7. Gets confirmation email

### Flow 2: [Name]

Example - Daily Automated Run:
1. System triggers at scheduled time
2. Pulls fresh data from all sources
3. Generates report with latest data
4. Emails to distribution list
5. Logs success/failure for user dashboard

## Constraints (Non-negotiable)
- **Performance**: [Specific limit]
- **Scale**: [Specific limit]
- **Security**: [Specific requirement]
- **Compatibility**: [What it must work with]

Example:
- **Performance**: Report generation <5 seconds for 1M rows
- **Scale**: Support 1,000 concurrent report builders
- **Security**: SOC2 compliant, data encrypted at rest
- **Compatibility**: Must work with existing SSO system

## Build Stages

### Stage 1: Prove It Works (2 weeks)
**Build**: [Minimal version]  
**Validate**: [Core assumption]  
**Success**: [User says "Yes, this helps!"]

Example:
**Build**: Connect to one data source, basic drag-drop builder, manual run only  
**Validate**: Users can build a report faster than Excel  
**Success**: 5 beta users say "This already saves me time"

### Stage 2: Make It Good (4 weeks)
**Improve**: [Based on what users loved/hated]  
**Polish**: [Remove friction points]  
**Success**: [Users prefer this to old way]

Example:
**Improve**: Add all 3 data sources, scheduling, email delivery  
**Polish**: Better error messages, loading states, preview  
**Success**: 50 users switch from Excel to this

### Stage 3: Make It Scale (2 weeks)
**Optimize**: [For all users, not just early adopters]  
**Harden**: [Security, reliability, performance]  
**Success**: [Handles real-world abuse gracefully]

Example:
**Optimize**: Queue system for concurrent reports, caching layer  
**Harden**: Rate limiting, audit logs, monitoring  
**Success**: 1,000 users, zero downtime, <5s generation

## The Experience
[2-3 sentences about how it should FEEL to use this. Give designers room to innovate.]

Example:
Building a report should feel as easy as making a slide in PowerPoint - drag, drop, done. The interface should suggest what you might want next, like a helpful colleague who knows your data. Power users can go deep, new users can't break anything.

## NOT Doing (Scope Control)
[What sounds related but is out of scope]

Example:
- Not building a full BI tool (use Tableau for complex analysis)
- Not supporting real-time streaming data (batch only)
- Not allowing custom code/scripts (security risk)
- Not replacing our data warehouse (just reading from it)

## Open Questions for Tech/Design
- [ ] [Questions that affect user experience]

Example:
- [ ] How do we handle when source data is unavailable? (Show stale? Error?)
- [ ] Should we auto-save draft reports? (How often?)
- [ ] What's the max report size before we need pagination?

---
**Status**: [Draft | Approved | In Development]  
**Owner**: @username  
**Last Updated**: YYYY-MM-DD