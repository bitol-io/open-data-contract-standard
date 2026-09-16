#!/usr/bin/env bash

# Copyright 2026 The Bitol Contributors
# SPDX-License-Identifier: Apache-2.0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
root_dir="${script_dir}/../.."
json_schema_version=${JSON_SCHEMA_VERSION:-v3.2.0}
num_failed_validation=0

python="${root_dir}/.venv/bin/python"
if [ ! -x "${python}" ]; then
  echo -e "${RED}.venv not found. Run: python3 -m venv .venv && .venv/bin/pip install -r requirements.txt${NC}"
  exit 1
fi

echo "Checking if $json_schema_version JSON schema is valid"
if "${python}" "${script_dir}/validate.py" compile -s "${root_dir}/schema/odcs-json-schema-${json_schema_version}.json"; then
  echo -e "${GREEN}Valid JSON schema${NC}"
else
  echo -e "${RED}Invalid JSON schema, exiting${NC}"
  exit 1
fi

echo -e "Validating example ODCS files based on ${json_schema_version} JSON schema"
for file in "${root_dir}"/docs/examples/*/*.yaml; do
  rel="${file#${root_dir}/}"
  if "${python}" "${script_dir}/validate.py" validate \
      -s "${root_dir}/schema/odcs-json-schema-${json_schema_version}.json" \
      -d "${file}"; then
    echo -e "${GREEN}Passed validation, file=${rel}${NC}"
  else
    echo -e "${RED}Failed validation, file=${rel}${NC}"
    num_failed_validation=$((num_failed_validation+1))
  fi
done

echo -e "${YELLOW}Total failed=${num_failed_validation}${NC}"
if [ "${num_failed_validation}" -gt 0 ]; then
  exit 1
else
  exit 0
fi
