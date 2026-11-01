# Dagster Azure Container App — disk exhaustion troubleshooting

**Incident:** `dagster-user-code` failed to load definitions with `OSError: [Errno 28] No space left on device` while dlt initialised `github_organisations_pipeline` from `ingestion/defs/github/loads.py`.

## Findings

- Root overlay filesystem: **20 GB used of 20 GB (100%)**, initially; after deleting some old dbt run directories: **17 GB used, 2.1 GB available (90%)**.
- dlt state under `/var/dlt/pipelines`: **~180 MB** — not the main disk consumer.
- `/opt/dagster/app`: **14 GB**; within it, `transformation/target`: **13 GB initially, 9.6 GB after partial cleanup**. `.venv`: **1.2 GB**.
- `target` contained many uniquely suffixed folders such as `dbt_build_non_engineer_kpi-...` (~111 MB each), `dbt_build_engineer_kpi-...` (~48 MB), and `dbt_test_partner_api-...` (~24 MB). These appear to be accumulated **per-invocation dbt artifacts**; the exact number and total breakdown were not established.
- The original GitHub/dlt failure was the **first observed write failure**, not evidence that GitHub ingestion caused the disk consumption.
- `/opt/dagster/logs` is on a separate Azure Files mount; its ample capacity does **not** increase available space on `/`.

## Diagnostic commands

Run inside the affected Azure Container App console.

```bash
# 1. Filesystem capacity; -h uses human-readable units.
df -h
# Check inode exhaustion as an alternative cause of write failures.
df -i

# 2. Size of top-level directories, on the root filesystem only.
# du measures files reachable under a path; -x avoids traversing mounts;
# -d 1 limits depth; sort -h sorts sizes numerically with units.
du -x -h -d 1 / 2>/dev/null | sort -h

# 3. Drill into the large application directory.
du -x -h -d 1 /opt/dagster/app 2>/dev/null | sort -h

# 4. Examine dbt target subdirectories, showing the largest 30.
du -x -h -d 1 /opt/dagster/app/transformation/target 2>/dev/null | sort -h | tail -30

# 5. Count only matching dbt build directories directly under target.
# A low count does not exclude dbt_test_* or other prefixes.
find /opt/dagster/app/transformation/target \
  -mindepth 1 -maxdepth 1 -type d -name 'dbt_build_*' | wc -l

# 6. Find large individual files in the app tree (>100 MB).
# -xdev stays on one filesystem; sizes printed in bytes.
find /opt/dagster/app -xdev -type f -size +100M \
  -printf '%s %p\n' 2>/dev/null | sort -nr | head -20

# 7. When df reports much more space than du, check unlinked open files.
# Requires lsof; an empty result is not definitive for overlay/image-layer usage.
lsof +L1 2>/dev/null | head -30
```

**How to interpret:** `df` describes filesystem-wide blocks; `du` sums visible files under specified directories. Differences can result from deleted-but-open files, filesystem/overlay accounting, or image layers. The largest `du` result is the next place to investigate. `2>/dev/null` suppresses permission and transient-file errors; remove it when debugging unexpected results.

## Cleanup used / further safe cleanup

A partial cleanup of stale `dbt_build_*` directories recovered roughly **3 GB**, but about **9.6 GB** remained under `transformation/target`. The prior `du ... | tail -30` output shows only the largest 30 entries, not the complete contents.

```bash
TARGET=/opt/dagster/app/transformation/target

# Check for running dbt processes before doing anything destructive.
ps aux | grep '[d]bt'

# Preview candidate invocation folders older than 24 hours.
# -mindepth/-maxdepth restrict matching to immediate children;
# -mmin +1440 means modified over 1,440 minutes ago.
find "$TARGET" -mindepth 1 -maxdepth 1 \
  -type d -name 'dbt_*' -mmin +1440 -print

# ONLY after ensuring no active jobs use these folders, and that the
# manifests/run-results/logs are no longer needed, delete previewed matches.
find "$TARGET" -mindepth 1 -maxdepth 1 \
  -type d -name 'dbt_*' -mmin +1440 -exec rm -rf -- {} +

# Check the result.
df -h /
du -sh "$TARGET"
```

**Warnings:** Age alone does not prove a directory is unused. Pause relevant jobs or otherwise confirm invocations have finished. The glob `dbt_*` is broad: review the preview before deleting. Do **not** delete `.venv`, live dbt output, or dlt pipeline state blindly. If a deletion does not free space, inspect open deleted files or restart processes only when safe.

## Prevent recurrence

- Configure a retention/cleanup process for **completed per-run dbt target directories** (for example, after 24–48 hours), while preserving directories in use and anything needed for diagnostics.
- Review how `DbtProjectComponent` / `DbtCliResource` generates invocation-specific target paths; avoid indiscriminately reusing one target path across concurrent runs.
- Monitor root filesystem usage and alert before capacity reaches 100%.
- Review `transformation/defs.yaml` and the Dagster/dbt version before choosing an integration-specific cleanup implementation.

**Status at last check:** Root filesystem still **90% full**; permanent cleanup and monitoring not yet implemented.
