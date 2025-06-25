# NEXUS Migration Guide: Blade Runner Terminology Update

## Overview

NEXUS v1.1 removes all Blade Runner references in favor of professional terminology. This guide helps you migrate existing projects.

## What Changed

### File Renames
| Old Name | New Name | Purpose |
|----------|----------|---------|
| `inception.log` | `operations.log` | System operation log |
| `retirement.log` | `errors.log` | Error tracking log |

### Directory Renames
| Old Path | New Path | Purpose |
|----------|----------|---------|
| `.pris/cells/` | `.pris/history/` | Historical snapshots |
| `.pris/cells/90-retirement/` | `.pris/history/90-deprecated/` | Deprecated artifacts |

## Migration Options

### Option 1: Automatic Migration (Recommended)

Run the initialization command - it will detect and offer to migrate:

```bash
# Copy 00-initialize.md command to Claude
# It will detect old structure and offer migration
```

### Option 2: Manual Migration

Run these commands in your project root:

```bash
# 1. Create backup
cp -r .pris .pris.backup.$(date +%Y%m%d-%H%M%S)

# 2. Rename log files
mv .pris/inception.log .pris/operations.log
mv .pris/retirement.log .pris/errors.log

# 3. Rename directories
mv .pris/cells .pris/history
[ -d .pris/history/90-retirement ] && mv .pris/history/90-retirement .pris/history/90-deprecated

# 4. Verify structure
ls -la .pris/
```

### Option 3: Using Migration Command

Use `92-migrate.md` for comprehensive migration with validation:

```bash
# Copy 92-migrate.md command to Claude
# Specify target version 1.1
```

## Impact on Your Code

### Scripts and Automation
Update any scripts that reference old paths:

```bash
# Old
tail -f .pris/inception.log

# New  
tail -f .pris/operations.log
```

### CI/CD Pipelines
Update any pipelines that read from or write to NEXUS directories.

### Documentation
Update any project documentation that references the old structure.

## Verification

After migration, verify:

1. **Log files exist:**
   ```bash
   ls -la .pris/*.log
   ```

2. **History directory structure:**
   ```bash
   ls -la .pris/history/
   ```

3. **No old paths remain:**
   ```bash
   # Should return no results
   ls .pris/inception.log .pris/retirement.log .pris/cells 2>/dev/null
   ```

## Rollback

If you need to rollback:

```bash
# Remove migrated structure
rm -rf .pris

# Restore from backup
mv .pris.backup.* .pris
```

## FAQ

**Q: Will this break my existing NEXUS workflow?**
A: No, only the file/directory names changed. All functionality remains the same.

**Q: Do I need to update my command files?**
A: If you're using the latest NEXUS commands, they already use the new paths.

**Q: What if I have custom scripts using old paths?**
A: You'll need to update them to use the new paths listed above.

**Q: Is this a breaking change?**
A: Yes, for existing projects. New projects will use the new structure automatically.

## Support

If you encounter issues:
1. Check the backup was created successfully
2. Verify all files were renamed (not deleted)
3. Review the error log for any issues
4. Use the rollback procedure if needed