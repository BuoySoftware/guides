# Kubernetes

## Resource Limits

- Define a [CPU resource request].
- Don't define a [CPU resource limit].
- Define a [memory resource request and limit].
- Ensure the [memory resource limit matches the request].
- Prefer to set CPU requests at a ratio of 1 CPU per 2 GB of RAM.

```yaml
resources:
  requests:
    memory: "2Gi"
    cpu: "1000m"
  limits:
    memory: "2Gi"
```

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

## ApplicationSets

- Use [ApplicationSets] with list generators to deploy an application across
  multiple environments from a single definition.
- For Kustomize-based applications, point the source path at the overlay
  directory: `{{rootFolder}}/jp/buoyrails/overlays/{{env}}`.
- For Helm-based infrastructure apps, use multi-source ApplicationSets with a
  `ref: values` source for values files.
- Use `CreateNamespace=true` in all sync policies.

[ApplicationSets]: https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/

## Kustomize Structure

- Use a layered base-and-overlay pattern.
- Define shared resources (deployments, services, jobs) in `prod/base/` or
  `non-prod/base/`.
- Use client bases (`prod/jp/base/`) to extend the shared base with
  client-specific patches.
- Use app bases (`prod/jp/buoyrails/base/`) to extend the client base with
  app-specific labels.
- Use overlays (`prod/jp/buoyrails/overlays/prod/`) for environment-specific
  namespace, patches, image tags, and transformers.
- Use reusable Kustomize components in `components/` for shared transformers
  (global labels, Datadog labels, name prefixes).

## Image Management

- Set image tags in overlay `kustomization.yaml` files using the `images:` field.
- Use release tags (`tag-v25.1`) for production and stable environments.
- Use SHA tags (`sha-8e86f72`) for development and alpha/beta environments.

## Labels

- Use `labels.buoy.software/domain` for the application domain.
- Use `labels.buoy.software/env` for the environment name.
- Use `labels.buoy.software/namespace` for the namespace identifier.
- Use `labels.buoy.software/product` for multi-product environments.
- Use `app.kubernetes.io/managed-by` set to `ArgoCD`.
- Use `app.kubernetes.io/part-of` for application grouping (e.g.,
  `jp-production`).
- Use `tags.datadoghq.com/env` and `tags.datadoghq.com/service` for Datadog
  integration.
- Apply labels through Kustomize `LabelTransformer` resources in `labels.yaml`
  files at each layer.

## Secrets

- Use [External Secrets Operator] to sync secrets from AWS Secrets Manager and
  SSM Parameter Store into Kubernetes Secrets.
- Store External Secrets configuration in the ArgoCD repository under
  `external-secrets/<app>/<cluster>/`.
- Use `SecretProviderClass` resources with the AWS Secrets Store CSI Driver for
  application secrets. Define them in the Kustomize base and patch per
  environment.

[External Secrets Operator]: https://external-secrets.io/
