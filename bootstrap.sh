#!/bin/bash

set -euo pipefail

# Install argocd from raw manifest
kubectl apply -f manifest/bootstrap/demo/argocd/argocd.yaml

# Wait for argocd server to be ready
echo "Waiting for ArgoCD crds..."
kubectl wait --for=condition=Established --timeout=180s crd/applications.argoproj.io crd/appprojects.argoproj.io

# Install applications
echo "Install applications..."
kubectl apply -f manifest/bootstrap/demo/applications/applications.yaml

# Print admin password
echo "ArgoCD initial admin password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
