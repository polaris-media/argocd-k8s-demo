#!/bin/bash

set -euo pipefail

# Install argocd from raw manifest
microk8s kubectl apply -f manifest/bootstrap/demo/argocd/argocd.yaml

# Wait for argocd server to be ready
echo "Waiting for ArgoCD crds..."
microk8s kubectl wait --for=condition=Established --timeout=180s crd/applications.argoproj.io crd/appprojects.argoproj.io

# Install applications
echo "Install applications..."
microk8s kubectl apply -f manifest/bootstrap/demo/applications/applications.yaml

# Print admin password
sleep 5  # Wait for secret to be created
echo "ArgoCD initial admin password: "
microk8s kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d