# Kubernetes

## Resource Limits

- Define a [CPU resource request].
- Define a [memory resource request and limit].
- Ensure the [memory resource limit matches the request].

### Workload Pods

- Don't define a [CPU resource limit].
- Prefer to set CPU requests at a ratio of 1 CPU per 2 GB of RAM unless there
  is a good reason to deviate for a specific workload.

```yaml
resources:
  requests:
    memory: "2Gi"
    cpu: "1000m"
  limits:
    memory: "2Gi"
```

Workload pods include:

- Ruby on Rails applications
- CI/CD runners
- Airbyte jobs

### Non-Workload Pods

- Define a CPU resource limit so workload pods processing data can leverage the
  leftover CPU, and to ensure non-workload pods won't impact other pods.
- Set a minimum of 100m / 100Mi.
- Set CPU and memory to what makes sense for the pod and monitor.

Non-workload pods include background pods that perform monitoring or similar
low-resource tasks.

[CPU resource request]: examples/resources.yaml
[CPU resource limit]: https://home.robusta.dev/blog/stop-using-cpu-limits
[memory resource request and limit]: examples/resources.yaml
[memory resource limit matches the request]: https://home.robusta.dev/blog/kubernetes-memory-limit

## Deployment

- Deploy all applications to EKS via [ArgoCD] using Kustomize overlays and Helm
  charts.
- Use the [ArgoCD repository] as the source of truth for all Kubernetes
  manifests.
- Use manual sync for production applications. Automated sync with self-heal is
  acceptable for internal development environments.

[ArgoCD]: https://argo-cd.readthedocs.io/
[ArgoCD repository]: https://github.com/BuoySoftware/ArgoCD

## Naming

- Use the pattern `{client}-{environment}` for namespaces: `jp-prod`,
  `jp-stage`, `csl-dev`.
- Use `{client}-{environment}-{product}` for multi-product namespaces:
  `buoy-alpha-dms`, `buoy-beta-pms`.
- Use the pattern `{client}-{env}-{app}` for ArgoCD Application names:
  `jp-prod-buoyrails`, `jp-stage-infirmary`.
- Use `{client}-{env}-{product}-{app}` for multi-product Application names:
  `buoy-alpha-dms-buoyrails`, `buoy-beta-pms-wharf`.

## Image Tags

- Use release tags (`tag-v25.1`) for production and stable environments.
- Use SHA tags (`sha-8e86f72`) for development and alpha/beta environments.

## Labels

- Use the `labels.buoy.software/*` namespace for custom application labels
  (domain, environment, namespace, product).
- Use standard `app.kubernetes.io/*` labels for Kubernetes metadata.

## Secrets

- Use [External Secrets Operator] to sync secrets from AWS Secrets Manager and
  SSM Parameter Store into Kubernetes Secrets.
- Use `SecretProviderClass` resources with the AWS Secrets Store CSI Driver for
  application secrets.

[External Secrets Operator]: https://external-secrets.io/
