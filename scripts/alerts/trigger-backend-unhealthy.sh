#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-burgerbuilder-group1}"
BACKEND_APP_NAME="${BACKEND_APP_NAME:-app-bb-backend-dev-group1}"
SECONDS_TO_WAIT="${1:-600}"

cleanup() {
  az webapp start --resource-group "${RESOURCE_GROUP}" --name "${BACKEND_APP_NAME}" --output table
}

trap cleanup EXIT

az webapp stop --resource-group "${RESOURCE_GROUP}" --name "${BACKEND_APP_NAME}" --output table
sleep "${SECONDS_TO_WAIT}"
