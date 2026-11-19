# Linux Observability Monitoring Stack

A containerized Linux infrastructure observability solution using **Prometheus, Grafana, Alertmanager, Node Exporter, and Docker Compose**.

## Overview

This project brings together infrastructure metrics collection, alert evaluation, notification routing, and dashboard visualization in a reproducible monitoring architecture. It reflects practical Linux platform engineering workflows, including resource monitoring, service availability checks, operational validation, and alert management.

## Architecture

```text
Linux Host
    |
    v
Node Exporter (:9100)
    |
    | metrics scrape
    v
Prometheus (:9090) -------> Alertmanager (:9093)
    |                         alert routing
    | PromQL
    v
Grafana (:3000)
```

Prometheus scrapes host metrics from Node Exporter and evaluates alert rules. Grafana queries Prometheus for visualizations. Alertmanager groups and routes alerts according to its configured receivers.

## Features

- Containerized monitoring services managed through Docker Compose
- CPU, memory, disk space, and exporter availability alerts
- Automatically provisioned Grafana data source and Linux dashboard
- Prometheus scrape configuration and alert-rule validation
- Operational health checks for service readiness and metrics collection
- GitHub Actions checks for configuration and dashboard integrity

## Quick start

Requirements: Linux, Docker Engine with the Docker Compose plugin, and curl.

```bash
cp .env.example .env
# Set a unique Grafana administrator password in .env
docker compose config --quiet
docker compose up -d
docker compose ps
bash scripts/validate.sh
```

Local interfaces:

| Service | URL |
| --- | --- |
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9090 |
| Alertmanager | http://localhost:9093 |

Grafana administrator credentials are read from the local `.env` file.

## Monitoring and alerting

The `linux-node` scrape job collects host metrics every 15 seconds. Prometheus evaluates rules every 15 seconds.

| Alert | Condition | Duration |
| --- | --- | --- |
| NodeExporterDown | Exporter unavailable | 2 minutes |
| HighCpuUsage | CPU utilization above 85% | 10 minutes |
| HighMemoryUsage | Memory utilization above 90% | 10 minutes |
| LowDiskSpace | Available filesystem space below 10% | 10 minutes |

Alertmanager includes a local routing configuration. Configure an appropriate receiver before using external notifications.

## Validation

```bash
docker compose config --quiet
docker compose run --rm --no-deps --entrypoint promtool prometheus check config /etc/prometheus/prometheus.yml
docker compose run --rm --no-deps --entrypoint promtool prometheus check rules /etc/prometheus/alerts.yml
bash scripts/validate.sh
```

The GitHub Actions workflow performs static checks on each push and pull request.

## Repository structure

```text
.
├── .github/workflows/validate.yml
├── alertmanager/alertmanager.yml
├── grafana/
│   ├── dashboards/linux-overview.json
│   └── provisioning/
│       ├── dashboards/default.yml
│       └── datasources/prometheus.yml
├── prometheus/
│   ├── alerts.yml
│   └── prometheus.yml
├── scripts/validate.sh
├── .env.example
└── compose.yaml
```

## Engineering considerations

- **Observability:** Correlate infrastructure resource utilization with target availability.
- **Reliability:** Use sustained alert conditions to reduce transient noise.
- **Operational readiness:** Validate configuration before deployment and check endpoints after startup.
- **Security:** Bind dashboard and management interfaces to localhost; apply authentication, TLS, and network access controls before remote exposure.
- **Maintainability:** Keep monitoring rules, provisioning, and deployment configuration under version control.

## Technology stack

Linux · Docker Compose · Prometheus · PromQL · Grafana · Alertmanager · Node Exporter · Bash · GitHub Actions
