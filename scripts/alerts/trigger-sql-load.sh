#!/usr/bin/env bash
set -euo pipefail

GATEWAY_BASE_URL="${GATEWAY_BASE_URL:-http://4.232.95.231}"
DURATION_SECONDS="${1:-600}"
CONCURRENCY="${2:-8}"
END_TIME=$((SECONDS + DURATION_SECONDS))

worker() {
  local session_id="sql-alert-$RANDOM"
  while [ "${SECONDS}" -lt "${END_TIME}" ]; do
    curl -fsS "${GATEWAY_BASE_URL}/api/ingredients" > /dev/null || true
    curl -fsS "${GATEWAY_BASE_URL}/api/orders/history" > /dev/null || true
    curl -fsS -X POST \
      -H "Content-Type: application/json" \
      -d "{\"sessionId\":\"${session_id}\",\"customerName\":\"Alert Demo\",\"customerEmail\":\"alert-demo@example.com\",\"customerPhone\":\"0000000000\",\"cartItemIds\":[]}" \
      "${GATEWAY_BASE_URL}/api/orders" > /dev/null || true
  done
}

for _ in $(seq 1 "${CONCURRENCY}"); do
  worker &
done

wait
