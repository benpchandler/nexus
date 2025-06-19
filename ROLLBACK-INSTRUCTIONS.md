# PRIS Simplicity Detection - Rollback Instructions

## Quick Rollback (if needed)

If the simplicity detection changes cause issues, you can easily roll back:

### Option 1: Full Rollback to Pre-Simplicity State
```bash
git reset --hard v1.0.0-pre-simplicity
```
This will completely undo all simplicity detection changes and return PRIS to its previous state.

### Option 2: Selective Rollback (if only some changes are problematic)
```bash
# View what changed
git show v1.0.0-pre-simplicity..HEAD --name-only

# Reset specific files if needed
git checkout v1.0.0-pre-simplicity -- commands/01-voight-kampff.md
git checkout v1.0.0-pre-simplicity -- commands/03-tyrell.md
# etc.
```

### Option 3: Temporary Disable (keep changes but disable functionality)
Edit `.pris/config.yaml` and set:
```yaml
# Disable pattern library to prevent minimal patterns from being used
patterns:
  enabled: false

# Disable sub-agent orchestration improvements  
sub_agents:
  enabled: false
```

## What Changed (for targeted fixes)

### Core Files Modified:
- `commands/01-voight-kampff.md` - Added simplicity detection question
- `commands/03-tyrell.md` - Added simplicity mode architecture selection
- `commands/05-verify.md` - Added context-aware testing  
- `commands/06-build.md` - Added appropriate build standards
- `commands/07-construct.md` - Added simplicity mode checks
- `commands/14-spawn.md` - Added sub-agent simplicity controls

### Files Added:
- `.pris/patterns/api/minimal-crud.pattern.md` - Simple CRUD pattern
- `.pris/patterns/frontend/simple-dashboard.pattern.md` - Simple dashboard
- `.pris/patterns/api/url-shortener.pattern.md` - URL shortener pattern
- `enhancements/evaluation/` - Complete test results and analysis

### Configuration:
- `.pris/config.yaml` - PRIS feature configuration

## Testing Rollback

After rollback, test with a simple project:
1. Use 01-voight-kampff on a "simple URL shortener" 
2. If it starts asking 20+ questions about enterprise features, rollback was successful
3. If it asks the simplicity question, rollback was incomplete

## Recovery Process

If you need to restore the simplicity detection later:
```bash
git checkout v1.1.0-simplicity-detection
```

## Tags Available

- `v1.0.0-pre-simplicity` - State before changes (rollback point)
- `v1.1.0-simplicity-detection` - Complete simplicity detection system

## Validation

The changes are extensive but well-contained:
- ✅ All changes are additive (no core PRIS functionality removed)
- ✅ Clean git history with logical commits
- ✅ Tagged rollback points available  
- ✅ Comprehensive test results documenting improvements
- ✅ Can disable features via configuration

## Contact

If you need assistance with rollback or encounter issues:
- Check the evaluation results in `enhancements/evaluation/`
- Review the improvement methodology in the test files
- All changes are documented with clear rationale