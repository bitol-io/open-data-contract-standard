---
title: "Contributing: Open Data Contract Standard (ODCS)"
description: "How you can contribute to the Open Data Contract Standard (ODCS)."
image: "https://raw.githubusercontent.com/bitol-io/artwork/main/horizontal/color/Bitol_Logo_color.svg"
---

# Contributing to Open Data Contract Standard

Thank you for your interest in contributing to Open Data Contract Standard (ODCS). Please refer to the [TSC contributing guidelines](https://github.com/bitol-io/tsc/blob/main/CONTRIBUTING.md).

## Create a Local Development Environment

To set up a local development environment, use the predefined setup scripts:

<details><summary>For Windows Development Environment run:</summary>

```shell
. \scr\script\dev_setup.ps1
```

</details>

<details><summary>For Unix Development Environment run:</summary>

```bash
source src/script/dev_setup.sh
```

</details>

Each of these scripts will:

* Check the virtual environment:
    * Create and activate it if missing
    * Activate it if not already active
* Check `pip` status:
    * Verify the current version
    * Compare against the latest version
    * Upgrade if necessary
* Check `pre_commit` status:
    * Install if missing
* Check `pre-commit` version:
    * Verify the current version
    * Compare against the latest version
    * Upgrade if necessary
* Check `pre-commit` hooks:
    * Create `.pre-commit-config.yaml` if missing
    * Update and install all hooks
* Check `.markdownlint.json`:
    * Create the file if it doesn’t exist
