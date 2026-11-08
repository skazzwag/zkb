---
name: dagster-fido-dagster
description: 'Dagster + dg CLI: Change Dagster defs, schedules, and the SQL-to-dbt-to-partner-API warehouse chain in ingestion/defs/.'
---

# Fido Dagster

> **Primary tool:** Dagster definitions and dg CLI (development-only execution when approved).

Read `.opencode/rules/dagster.md`.

## Checklist

1. New dlt loads get a folder under `ingestion/defs/` with `defs.yaml` and `loads.py`, matching existing sources (github, hubspot, jira, sonarqube, partner_api). The extractor itself belongs under `ingestion/sources/api/<name>/` (or `sql_schema/` / `blob_storage/` / `database/`). Read `.opencode/rules/repo-structure.md`.
2. Wire the source in `ingestion/sources/` and `ingestion/glossary.py` / runners if the load is SQL or blob.
3. Warehouse chain order: CoIoTe / SQL ingest → `dbt_ops_job` / `dbt_job` → `dbt_partner_api_tests_job` → `partner_api_job`. Do not insert a job that breaks that order without saying so.
4. Reverse ETL: `ingestion/defs/partner_api/` reads MotherDuck `act_partner_api_waypoints` into Partner API Postgres.
5. Local check the user can run: `uv run dg check defs`. Docker: `make serve`. Lightweight: `make dev`.
6. Do not run dbt through Dagster in this setup; eligible roles use the dev-only runner. Orchestrator execution needs a separate reviewed operational policy.
7. Never put secrets in defs. Inherit env.

Do not execute dbt through Dagster during agent work; eligible roles use only the approved dev runner. Production orchestration remains CI/operator-controlled.
