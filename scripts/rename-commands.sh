#!/bin/bash
# PRIS Command Renaming Script
# Converts JIM command files to PRIS naming

echo "🔄 Converting JIM commands to PRIS..."

# Create command mappings
declare -A command_map=(
    ["00-init"]="00-baseline"
    ["01-analyze"]="01-voight-kampff"
    ["02-prioritize"]="02-joshi"
    ["025-architecture"]="03-tyrell"
    ["03-setup"]="04-sebastian"
    ["030-orchestrate"]="05-wallace"
    ["035-decompose"]="06-cells"
    ["04-implement"]="07-construct"
    ["040-sync"]="08-mesh"
    ["045-coordinate"]="09-stelline"
    ["05-review"]="10-deckard"
    ["15-validate"]="11-vk"
    ["90-improve-prompts"]="12-morehuman"
    ["90-migrate"]="13-tearsInRain"
    ["95-validate-structure"]="00-baseline-validate"
)

# Rename command files
for old_name in "${!command_map[@]}"; do
    new_name="${command_map[$old_name]}"
    if [ -f "commands/${old_name}.md" ]; then
        echo "  ✓ ${old_name}.md → ${new_name}.md"
        mv "commands/${old_name}.md" "commands/${new_name}.md"
    fi
done

echo "✅ Command conversion complete!"
echo ""
echo "Next steps:"
echo "1. Update command content to reflect new names"
echo "2. Merge 00-baseline-validate logic into 00-baseline"
echo "3. Update all JIM references to PRIS"