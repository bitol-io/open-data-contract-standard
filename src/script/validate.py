#!/usr/bin/env python3

# Copyright 2026 The Bitol Contributors
# SPDX-License-Identifier: Apache-2.0

"""Validate ODCS YAML files against the JSON schema (draft 2019-09)."""

import argparse
import json
import sys

import yaml
from jsonschema import Draft201909Validator
from jsonschema.exceptions import SchemaError


def cmd_compile(args):
    with open(args.schema) as f:
        schema = json.load(f)
    try:
        Draft201909Validator.check_schema(schema)
        Draft201909Validator(schema)
    except SchemaError as e:
        print(f"Invalid schema: {e.message}", file=sys.stderr)
        sys.exit(1)
    print("Schema is valid")


def cmd_validate(args):
    with open(args.schema) as f:
        schema = json.load(f)
    with open(args.data) as f:
        data = yaml.safe_load(f)

    validator = Draft201909Validator(schema)
    errors = list(validator.iter_errors(data))
    if errors:
        for err in errors:
            path = "/".join(str(p) for p in err.absolute_path) or "(root)"
            print(f"  {path}: {err.message}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)

    p_compile = sub.add_parser("compile")
    p_compile.add_argument("-s", "--schema", required=True)

    p_validate = sub.add_parser("validate")
    p_validate.add_argument("-s", "--schema", required=True)
    p_validate.add_argument("-d", "--data", required=True)

    args = parser.parse_args()
    {"compile": cmd_compile, "validate": cmd_validate}[args.command](args)
