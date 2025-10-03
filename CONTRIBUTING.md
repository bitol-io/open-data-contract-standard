---
title: "Contributing: Open Data Contract Standard (ODCS)"
description: "How you can contribute to the Open Data Contract Standard (ODCS)."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Contributing to Open Data Contract Standard

Thank you for your interest in contributing to Open Data Contract Standard (ODCS). Please refer to the [TSC contributing guidelines](https://github.com/bitol-io/tsc/blob/main/CONTRIBUTING.md).

## Create a local development environment

* Create a Python virtual environment

```bash
python -m venv .venv
```

* Activate the virtual environment

    <details><summary>Windows Development Environment</summary>

    ```bash
    .venv/Scripts/activate
    ```

    </details>

    <details><summary>Unix Development Environment</summary>

    ```bash
    source .venv/bin/activate
    ```

    </details>

* Install the required dependencies

```bash
pip install -r requirements.txt
```

* Install the pre-commit hooks

```bash
pre-commit install
```
