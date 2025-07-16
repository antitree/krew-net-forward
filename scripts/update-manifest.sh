#!/usr/bin/env bash
set -euo pipefail

VERSION=${1:?"version required"}
SHA256=${2:?"sha256 required"}
OWNER=${3:-REPO_OWNER}

sed \
  -e "s/{{VERSION}}/${VERSION}/g" \
  -e "s/{{REPO_OWNER}}/${OWNER}/g" \
  -e "s/{{SHA256}}/${SHA256}/g" \
  krew-plugin.yaml > dist/net-forward.yaml
