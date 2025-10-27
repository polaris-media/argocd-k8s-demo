# Bootstrap and config clusters demo

Demonstration repository for how we bootstrap a Kubernetes cluster with ArgoCD.

## Prerequisites

- A working Kubernetes cluster (Minikube, MicroK8s, Kind, or any kind of kubernetes)
- `kubectl` configured to talk to a cluster
- `kustomize`
- `argocd` CLI (optional)

## Repository Structure

```text
.
├── applicationsets
├── manifest/
    └── bootsrap/
        └── <cluster>/
            └── argocd/
└── src/
    └── bootstrap/
        └── clusters/
            └── <cluster>/
    ├── helm/
        └── clusters/
            └── <cluster>/<addons>
    └── kustomize/
        └── base/
        └── clusters/
            └── <cluster>/<addons>
```

- `applicationsets` holds root-level ApplicationSet
- `manifest/` Rendered manifests for bootstrapping
- `src/addons` configured addons
- `src/bootstrap` argocd configuration

## How it works

### TLDR

Bootstrap cluster with argocd.
ArgoCD now manages the cluster, addons and apps through this repoistory.

### What actually happens

We use an app of apps pattern.

This repository contans a application which is "loaded" into argocd when bootstrapping the cluster.
This application points back to this repoistory, eg. single source of truth,

ArgoCD now manages the cluster addons and itself.

One of these apps in (src/addons/kustomize/demo/pkl-demo) is another app of apps, however this application points to the repository containing the apps.

ArgoCD no also manages all the application

## How to test it

Manual steps below, optionally run the ./bootstrap script

1. **Bootstrap Argo CD**

    ```bash
    kubectl apply -f manifest/bootstrap/demo/argocd/argocd.yaml

    kubectl apply -f manifest/bootstrap/demo/applications/applications.yaml
    ```

2. **Bootstrap ArgoCD applications**

    ```bash
    kubectl apply -f manifest/bootstrap/demo/applications/applications.yaml
    ```

3. **Get ArgoCD admin pwassword**

    ```bash
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    ```

4. **Connect to argocd**

    Use the ready made ingress https://localhost:9443 or do some manual port forwarding

    example:

    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

## Other

An ingress is installed as a "showcase" for using helm charts
