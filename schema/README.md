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

Dated snapshots split into two phases for a given minor line:

- **Pre-release** — snapshots dated *before* the release date of `vX.Y.Z`. These capture working drafts during development.
- **Post-release** — the snapshot dated on the release date of `vX.Y.Z` and every snapshot dated after it. These capture silent fixes that landed in the rolling `odcs-json-schema-vX.Y.Z.json` after the version shipped.

The retention rule:

1. **At the release of `vX.Y.Z`**, all pre-release snapshots for that line are pruned down to a **single snapshot — the one immediately preceding the release date**. Earlier pre-release iteration snapshots are deleted.
2. **Post-release snapshots are kept indefinitely.** They document the silent-fix history of the rolling minor file and are the right pin for downstream consumers who need byte-stable validation across silent updates.
3. The rolling `odcs-json-schema-vX.Y.Z.json` file itself is never deleted.

Worked example — `v3.1.0` was released on **2025-12-08**:

- Pre-release dates: `20250724`, `20250813`, `20250819`, `20250916`, `20250922`, `20250923`, `20251007`, `20251014`, `20251117`, `20251118`, `20251119`, `20251120`, `20251123`, `20251203`, `20251205`. Of these, only `v3.1.0-20251205.json` is kept (the snapshot immediately preceding the release date); the other 14 are deleted.
- Post-release dates: `20251208`, `20251229`, `20260225`, `20260415`, `20260429`. All kept.

The same rule applies to `v3.2.0`. Until `v3.2.0` ships, all `v3.2.0-YYYYMMDD.json` files are pre-release; at release time they will be pruned to the single snapshot immediately preceding the release date, and post-release patch snapshots will accumulate from there.

Rationale: pre-release iteration snapshots are mostly noise to downstream consumers — they can already see the same content in git history. Post-release snapshots, by contrast, are the only way to recover the exact state of a "silent fix" iteration after the rolling file moves on.

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

## Snapshot changelog

Concise summary of what changed between each retained dated snapshot.

### v3.1.0 line

| Date       | Notes                                                                                                                                       |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| 2025-12-05 | Pre-release pin — final development state immediately before the 2025-12-08 v3.1.0 release.                                                 |
| 2025-12-08 | **Initial v3.1.0 release** (also incorporates the `AthenaServer` → `ApiServer` title rename that landed on `dev`).                          |
| 2025-12-29 | Server-specific `required` lists dropped (API `location`, Athena `stagingDir`/`schema`) so individual server fields can be optional. Server title reverts to `AthenaServer`. |
| 2026-02-25 | Shorthand reference regex relaxed to allow more than two segments (e.g., `a.b.c.d` is now valid).                                           |
| 2026-04-15 | Athena server: `stagingDir` made optional; new optional `workgroup` field added.                                                            |
| 2026-04-29 | Athena changes from 2026-04-15 reverted out of the v3.1.0 line to keep it stable; same changes are carried forward in `latest` and `v3.2.0` instead. |

### v3.2.0 line

| Date       | Notes                                                                                                                                                  |
|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2026-04-29 | First v3.2.0 snapshot. `apiVersion` default raised to `v3.2.0`. Adds RFC 0033 (Enum): new `enum` array on schema properties, new `EnumValue` `$def`.   |

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
