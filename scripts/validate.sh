#!/usr/bin/env bash
set -euo pipefail

for service in prometheus alertmanager node-exporter grafana; do
  status="$(docker compose ps --status running --services)"
  if ! grep -Fxq "$service" <<< "$status"; then
    echo "FAIL: $service is not running" >&2
    exit 1
  fi
done

for endpoint in http://127.0.0.1:9090/-/ready http://127.0.0.1:9093/-/ready http://127.0.0.1:3000/api/health; do
  curl --fail --silent --show-error --max-time 10 "$endpoint" >/dev/null
  echo "OK: $endpoint"
done

curl --fail --silent --show-error --max-time 10 http://127.0.0.1:9090/api/v1/targets | grep -q '"health":"up"' || {
  echo "FAIL: no healthy Prometheus target" >&2
  exit 1
}
echo "PASS: monitoring endpoints and at least one scrape target are healthy"
