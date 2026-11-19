# Linux Observability Monitoring Stack

A reproducible Linux infrastructure monitoring lab using **Prometheus, Grafana, Alertmanager, Node Exporter, and Docker Compose**.

## Architecture

```text
Linux host / Node Exporter (:9100)
           |
           v
Prometheus (:9090) -- alert rules --> Alertmanager (:9093)
           |
           v
Grafana (:3000)
```

## Quick start

Requirements: Docker Engine with Compose plugin and a Linux host.

```bash
cp .env.example .env
docker compose config --quiet
docker compose up -d
docker compose ps
./scripts/validate.sh
```

Open Grafana at http://localhost:3000, Prometheus at http://localhost:9090 and Alertmanager at http://localhost:9093. Grafana credentials are set in your local `.env` file; change the example password before exposing any service. The Prometheus data source and Linux overview dashboard are provisioned automatically.

**Security:** This lab publishes ports on localhost only. Do not expose it publicly without authentication, TLS and access controls. No employer infrastructure, addresses, credentials or operational data are used.

## Testing

```bash
docker compose config --quiet
docker compose run --rm --no-deps prometheus promtool check config /etc/prometheus/prometheus.yml
docker compose run --rm --no-deps prometheus promtool check rules /etc/prometheus/alerts.yml
./scripts/validate.sh
```

The validation script checks running service endpoints and requires the stack to be started.

## Layout

- `compose.yaml`: local monitoring services
- `prometheus/`: scrape targets and alert rules
- `alertmanager/`: example alert routing
- `grafana/provisioning/`: data source and dashboard provisioning
- `grafana/dashboards/`: Linux overview dashboard
- `scripts/`: operational validation
- `.github/workflows/`: automated static checks

