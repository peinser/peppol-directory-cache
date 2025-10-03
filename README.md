
# Peppol Directory Cache

## Overview

Peppol Directory Cache is a lightweight caching proxy for the [Peppol Directory](https://directory.peppol.eu/search/1.0/json). It extracts Peppol Participant IDs and their registered document types, enabling fast, reliable lookups during invoice and credit-note generation.

> **Why is this increasingly important?**

The Peppol landscape is rapidly evolving, with Access Points and participants adopting different document types, processes, and even legacy schemes. In the future, it will be essential to select the correct UBL document type and Participant ID for each client—some may only support specific types (e.g., credit-notes only), or use legacy scheme IDs such as `0208`. Failing to do so can result in undeliverable invoices or compliance issues. This fragmentation means services like this cache are critical for reliably determining what your client actually supports, ensuring seamless and correct electronic document exchange.

We expect the cache requires a lot of refreshing in the upcoming months because it will take some time before companies settle with the proper Peppol provider, and of course, the longevity of the _many_ Peppol providers remains a big question as well of course. From this point of view, we recommend to _currently_ (in)validate the contents of the cache as required. In the future however, this will most likely change when things have settled.

## Why Use This Utility?

- **Performance:** Reduces latency and load on the Peppol Directory by caching responses for repeated queries.
- **Reliability:** Mitigates rate limiting and service interruptions from the upstream directory.
- **Correctness:** Ensures you generate the right UBL document type for each client, even as the Peppol landscape fragments.

## How It Works

During invoice or credit-note generation, query the cache with parameters like `q=BE&q={CompanyNumber}`. The cache will return Peppol information for the specified company, including supported document types. This helps you select the correct UBL type for each transaction.

## Caching Controls & Recommendations

- **Write-through cache:** Responses are cached for a configurable period (default: 1 year for HTTP 200 responses).
- **Explicit cache purging:** Implement cache purging logic for stale or changed participant data. (See TODO)
- **Initial load:** For large client bases, pre-populate the cache to avoid rate limits and slow startup.
- **Single instance purging:** Only one instance should purge the cache in enterprise deployments to avoid rate limiting.
- **Rate limiting:** Avoid bulk queries or frequent purges from multiple sources.

## Example Queries

Query Peppol information for well-known companies:

### Belgian government (Company Number: 0203.201.340)

```bash
curl -s "http://<your-cache-host>:8000?q=BE&q=0203201340"
```

### KBC Bank NV (Company Number: 0403.227.515)

```bash
curl -s "http://<your-cache-host>:8000?q=BE&q=0403227515"
```

### Proximus NV (Company Number: 0202.239.951)

```bash
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
helm install my-peppol-cache k8s/helm/charts/peppol-directory-cache --set defaults.ingress.enabled=false
```

## TODO

- [ ] Implement explicit cache purging controls for specific query arguments.
- [ ] Add scripts for initial load and cache management.

## References

- [Peppol Directory API](https://directory.peppol.eu/search/1.0/json)
