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
ArgoCD now manages the cluster, addons and apps are installed.

### What actually happens

argocd manifest contains an application which reads all appsets (applicationsets) from the root directory of this repoistory
appsets points to directories in the different directories for the specific cluster

In src/kustomize/base/pkl-demo we have another application which points to a repository with apps to run in the cluster

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

    Use the ready made ingress or expose a port for demonstration purposes

    example:

    ```bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

## Other

An ingress is installed as a "showcase".
