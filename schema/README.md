# ODCS JSON Schema — Versioning

This directory holds every published version of the Open Data Contract Standard (ODCS) JSON Schema.

If you want files to be auto-detected as ODCS, name them with the `.odcs.yaml` extension (e.g., `my-big-data.odcs.yaml`).

## File-naming policy

Three flavours of files coexist in this folder:

### 1. `odcs-json-schema-latest.json` — bleeding edge

Always tracks the **latest version of the standard, no questions asked**. May change at any time. Suitable for:

- Local IDE validation while you follow the most recent specification work
- Quickly testing whether your tooling stays compatible with upcoming releases

Not suitable for production pinning — its content can shift under you.

### 2. `odcs-json-schema-vX.Y.Z.json` — rolling minor latest

Always tracks the **latest version of the `vX.Y.Z` line**. The major+minor+patch in the filename is fixed; the file's content may receive **silent updates** as bug fixes, regex tightenings, typo corrections, or clarifying defaults are merged into that release line.

Examples:

- `odcs-json-schema-v3.1.0.json` — latest of the v3.1.0 line (silent bug-fix updates roll forward into this file).
- `odcs-json-schema-v3.2.0.json` — latest of the v3.2.0 line.
- `odcs-json-schema-v3.0.2.json` / `odcs-json-schema-v3.0.2-strict.json` — latest of the v3.0.2 line.

This is the right file for most consumers who want to validate against "ODCS v3.1.0" without caring whether a typo in a regex was fixed last Tuesday. It is **not byte-stable** across time.

### 3. `odcs-json-schema-vX.Y.Z-YYYYMMDD.json` — dated snapshot

A **frozen** snapshot of `odcs-json-schema-vX.Y.Z.json` as it stood on the date `YYYYMMDD` (UTC committer date). Contents will never change after publication. Suitable for:

- Reproducible CI pipelines
- Compliance/auditing scenarios where the exact validator must be archived alongside the contract
- Bisecting validation differences across schema iterations

Each modification of `odcs-json-schema-vX.Y.Z.json` produces a new dated snapshot. Multiple commits on the same day collapse into a single snapshot reflecting the **last commit of that day**.

This convention was introduced with **ODCS v3.2.0** and applied **retroactively to v3.1.0**. Earlier ODCS lines (`v3.0.x`, `v2.2.x`) are not back-filled.

### Retention

Dated snapshots accumulate while a minor version is the most recent line. **When a new minor version is released, we keep only the snapshot immediately preceding the release** for the line that just closed; all earlier dated snapshots of that line are deleted from the repository.

For example, when `v3.3.0` is released, the `v3.2.0-YYYYMMDD.json` files are pruned down to a single snapshot — the one taken right before `v3.3.0` shipped — so anyone needing the "final v3.2.0" can still pin to it. The rolling `odcs-json-schema-v3.2.0.json` file itself stays available indefinitely.

Rationale: dated snapshots are most valuable while a line is actively being patched. Once the line is superseded, the rolling minor file plus the pre-release snapshot give consumers everything they need (the final state and a stable archive point) without bloating the repository with iteration history.

## Recommended consumption

| Use case                                              | Recommended file                                   |
|-------------------------------------------------------|----------------------------------------------------|
| IDE schema hint while authoring contracts             | `odcs-json-schema-latest.json`                     |
| CI validation against the standard you target         | `odcs-json-schema-v<X.Y.Z>.json`                   |
| Reproducible audit / regulated environment            | `odcs-json-schema-v<X.Y.Z>-YYYYMMDD.json`          |
| Migrating from one minor version to the next          | Diff two `vX.Y.Z` files, or use `src/script/schema-diff.sh` |

## How dated snapshots are produced

After every change merged into `dev` that touches `odcs-json-schema-vX.Y.Z.json`, a snapshot named `odcs-json-schema-vX.Y.Z-YYYYMMDD.json` is committed alongside it. If a snapshot for the same day already exists, it is overwritten in place (i.e., the snapshot for a given day always reflects the last commit of that day in `dev`).

Past snapshots (before this policy was introduced) were back-filled from git history — for each day the v3.1.0 schema changed, the file content of the last commit of that day was extracted and committed as a dated snapshot.

## SchemaStore registration

ODCS is registered with [SchemaStore](https://github.com/SchemaStore/schemastore) so that editors like IntelliJ and VS Code recognise `.odcs.yaml` files automatically (see [PR 3868](https://github.com/SchemaStore/schemastore/pull/3868)).

When a new minor version of ODCS ships, open a PR against SchemaStore updating the `versions` map:

```json
{
  "name": "Open Data Contract Standard (ODCS)",
  "...": "...",
  "versions": {
    "<new_version>": "https://github.com/bitol-io/open-data-contract-standard/blob/main/schema/odcs-json-schema-<new_version>.json",
    "...": "..."
  }
}
```

Reference `odcs-json-schema-vX.Y.Z.json` (rolling minor latest) in SchemaStore — not the dated snapshots — so users transparently benefit from in-line bug fixes.
