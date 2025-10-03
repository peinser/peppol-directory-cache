# Peppol Directory Cache

## Purpose

This utility acts as a caching proxy for the [Peppol Directory](https://directory.peppol.eu/search/1.0/json), designed to extract Peppol Participant IDs and their registered document types. It is intended to accelerate and stabilize access to Peppol information, especially for use cases such as invoice generation, where up-to-date participant data is required.

### Typical Usage

During invoice generation, this service is queried with parameters such as `q=BE&q={CompanyNumber}` to fetch Peppol information for a specific company. The cache ensures that repeated lookups for the same company are served quickly and reliably, reducing load on the Peppol Directory and mitigating rate limits.

## Caching Controls

- **Write-through cache:** The service caches responses from the Peppol Directory for a configurable period (default: 1 year for HTTP 200 responses).
- **Explicit cache purging:** It is recommended to implement cache purging logic, especially when participant data changes or becomes stale. See TODO below.
- **Initial load:** For large client bases, consider pre-populating the cache with relevant participant data to avoid rate limits and slow startup times.

## Operational Recommendations

- **Single instance purging:** In enterprise deployments, ensure that only one instance is responsible for purging the cache. Multiple instances purging simultaneously may trigger rate limiting by the Peppol Directory and degrade service reliability.
- **Rate limiting:** The Peppol Directory enforces rate limits. Avoid bulk queries or frequent cache purges from multiple sources.

## TODO

- [ ] Implement explicit cache purging controls for specific query arguments

## References

- [Peppol Directory API](https://directory.peppol.eu/search/1.0/json)

## Example Queries

Below are example `curl` commands to query Peppol information for well-known companies using this cache service:

### Belgian government (Company Number: 0203.201.340)

```
curl -s "http://<your-cache-host>:8000?q=BE&q=0203201340"
```

### KBC Bank NV (Company Number: 0403.227.515)

```
curl -s "http://<your-cache-host>:8000?q=BE&q=0403227515"
```

### Proximus NV (Company Number: 0202.239.951)

```
curl -s "http://<your-cache-host>:8000?q=BE&q=0202239951"
```

Replace `<your-cache-host>` with the hostname or IP address of your deployed cache service.

## Docker Image & Deployment

You can use the official Docker image or build your own from this repository.

### Pull from Registry

```bash
docker pull harbor.peinser.com/library/peppol-directory-cache:0.0.1
```

### Build Locally

Clone the repository and build the image:

```bash
git clone https://github.com/peinser/peppol-directory-cache.git
cd peppol-directory-cache
docker build -f docker/Dockerfile -t peppol-directory-cache:local .
```

### Run the Container

```bash
docker run -p 8000:8000 peppol-directory-cache:local
```

### Kubernetes/Helm Deployment

Helm charts are provided in `k8s/helm/charts/peppol-directory-cache`.

```bash
helm install my-peppol-cache k8s/helm/charts/peppol-directory-cache  --set defaults.ingress.enabled=false
```
