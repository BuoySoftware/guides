
# Kubernetes

## Resource limits

- Define a [CPU resource request]
- Don't define a [CPU resource limit]
- Define a [memory resource request and limit]
- Ensure the [memory resource limit matches the request]
- Prefer to set CPU requests at a ratio of 1 CPU per 2 GB of RAM

[CPU resource request]: examples/resources.yaml
[CPU resource limit]: https://home.robusta.dev/blog/stop-using-cpu-limits
[memory resource request and limit]: examples/resources.yaml
[memory resource limit matches the request]: https://home.robusta.dev/blog/kubernetes-memory-limit
