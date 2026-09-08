#!/usr/bin/env bash

# Copyright 2026 The Bitol Contributors
# SPDX-License-Identifier: Apache-2.0

# `odcs-json-schema-latest.json` MUST be identical to the schema of the version
# under development. They are two names for one artifact: `latest` is what most
# tooling resolves to by default, the versioned file is what the release pins.
# Any difference between them means some consumers get a different standard than
# others, which is what happened with #322 — the map/vector guard was fixed in
# v3.2.0 and missed in latest.

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
schema_dir="${script_dir}/../../schema"
json_schema_version=${JSON_SCHEMA_VERSION:-v3.2.0}

latest="${schema_dir}/odcs-json-schema-latest.json"
versioned="${schema_dir}/odcs-json-schema-${json_schema_version}.json"

echo "Checking that odcs-json-schema-latest.json is identical to odcs-json-schema-${json_schema_version}.json"

if [ ! -f "${versioned}" ]; then
  echo -e "${RED}Missing ${versioned}${NC}"
  exit 1
fi

if diff -u "${versioned}" "${latest}"; then
  echo -e "${GREEN}Identical${NC}"
  exit 0
fi

echo -e "${RED}odcs-json-schema-latest.json and odcs-json-schema-${json_schema_version}.json differ.${NC}"
echo -e "${RED}They must be byte-identical: apply every schema change to BOTH files.${NC}"
exit 1
