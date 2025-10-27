#!/bin/bash

set -e  # Exit immediately if a command fails
set -o pipefail  # Catch errors in pipelines

# Directories to search for YAML files
YAML_DIRS=(
    "src/addons/helm"
    "src/apps/helm"
)

echo "🔍 Linting YAML files in the following directories: ${YAML_DIRS[*]}"

# Loop through each directory to find and lint YAML files
for yaml_dir in "${YAML_DIRS[@]}"; do
    if [[ -d "$yaml_dir" ]]; then
        echo "📂 Searching for YAML files in: $yaml_dir"

        # Find all .yaml or .yml files and lint them
        find "$yaml_dir" -type f \( -name "*.yaml" -or -name "*.yml" \) | while read -r file; do
            echo "🔍 Linting YAML file: $file"

            # Run yamllint and fail if any issue is found
            if ! yamllint "$file" >/dev/null; then
                yamllint "$file"
                echo "❌ YAML linting failed for file: $file!"
                exit 1
            fi

            echo "✅ YAML linting successful for: $file"
        done
    else
        echo "⚠️ Directory not found: $yaml_dir (skipping)"
    fi
done

echo "🎉 All YAML files linted successfully!"
