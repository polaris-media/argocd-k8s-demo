#!/bin/bash

set -e  # Exit immediately if a command fails
set -o pipefail  # Catch errors in pipelines

# List of parent directories to search in
SEARCH_DIRS=(
    "src/"
)

echo "🔍 Searching for kustomization.yaml in defined directories..."

# Loop through each search directory
for search_dir in "${SEARCH_DIRS[@]}"; do
    if [[ -d "$search_dir" ]]; then
        echo "📂 Searching in: $search_dir"

        # Find all kustomization.yaml files within the directory, skipping "components" directories
        find "$search_dir" -type f -name "kustomization.yaml" | while read -r file; do
            dir=$(dirname "$file")

            # Skip directories named "components"
            if [[ "$dir" == */components/* ]] || [[ "$(basename "$dir")" == "components" ]]; then
                echo "⚠️ Skipping Kustomize validation for component: $dir"
                continue
            fi

            echo "🔍 Validating Kustomize build in: $dir"

            if ! kustomize build "$dir" >/dev/null; then
                echo "❌ Kustomize build failed in $dir!"
                exit 1
            fi

            echo "✅ Kustomize build successful in $dir!"
        done
    else
        echo "⚠️ Directory not found: $search_dir (skipping)"
    fi
done

echo "🎉 All Kustomize builds validated successfully!"
