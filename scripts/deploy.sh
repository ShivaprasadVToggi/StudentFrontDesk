#!/usr/bin/env bash
# Deploy the College Front Desk metadata to a Salesforce org.
# Usage: bash scripts/deploy.sh [org-alias]
# Requires: Salesforce CLI (sf) authenticated to the target org.
set -euo pipefail

ORG_ALIAS="${1:-cfd-dev}"
echo "Deploying force-app to org alias: $ORG_ALIAS"
sf project deploy start \
  -d force-app \
  --target-org "$ORG_ALIAS" \
  --wait 15 \
  --ignore-conflicts

echo "Deploy complete. Assign permission sets to users via Setup -> Permission Sets."
echo "  - College_Front_Desk_Receptionist"
echo "  - College_Front_Desk_Staff"
echo "  - College_Front_Desk_Management"
