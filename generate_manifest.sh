#!/bin/bash

set -e  # Exit on any error

# Detect Kustomize command
if which kustomize > /dev/null; then
    KUSTOMIZE_CMD="kustomize build"
elif which kubectl > /dev/null; then
    KUSTOMIZE_CMD="kubectl kustomize"
else
    echo "Neither kustomize nor kubectl found. Exiting."
    exit 1
fi

# Define directories
BASE_DIR="src/bootstrap/clusters"
OUTPUT_DIR="manifest/bootstrap"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through all clusters
for cluster_dir in "$BASE_DIR"/*/; do
    [ -d "$cluster_dir" ] || continue  # Skip non-directories

    cluster_name=$(basename "$cluster_dir")
    cluster_output_dir="$OUTPUT_DIR/$cluster_name"

    # Remove old manifests and recreate the directory
    rm -rf "$cluster_output_dir"
    mkdir -p "$cluster_output_dir"

    # Loop through all apps within the cluster
    for app_dir in "$cluster_dir"/*/; do
        [ -d "$app_dir" ] || continue  # Skip non-directories
        if [ ! -f "$app_dir/kustomization.yaml" ] && [ ! -f "$app_dir/kustomization.yml" ] && [ ! -f "$app_dir/Kustomization" ]; then
            echo "Skipping $app_dir (no kustomization.yaml found)"
            continue
        fi

        app_name=$(basename "$app_dir")
        app_output_dir="$cluster_output_dir/$app_name"  # Create app-specific directory
        mkdir -p "$app_output_dir"  # Ensure the app directory exists

        output_file="$app_output_dir/$app_name.yaml"  # Save manifest as <app_name>.yaml

        echo "Building manifest for $cluster_name/$app_name..."
        $KUSTOMIZE_CMD "$app_dir" > "$output_file"

        echo "Manifest saved: $output_file"
    done
done

echo "All manifests generated successfully!"
