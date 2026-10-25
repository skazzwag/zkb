# Analytics pipelines template

Starter repository for a data stack with:

- **ingestion/** — dlt extract/load pipelines orchestrated by Dagster
- **transformation/** — dbt Core models (DuckDB / MotherDuck)
- **infrastructure/motherduck/** — SQL that creates warehouse databases, shares, and grants
- **partner_api/** — reverse-ETL / OpenAPI stubs for activating warehouse data

This template is a skeleton of an existing analytics-pipelines repo. Business-specific
models, secrets, local databases, logs, and git worktrees are omitted. Empty folders
are kept with `.gitkeep` so Git tracks the layout.

## Create a new repo from this template

1. Copy this `template/` directory into a new git repository (or use GitHub
   **Use this template** after you publish it as a template repo).
2. Search-and-replace `warehouse_transforms` and `analytics_warehouse` with your
   project names.
3. Copy `.env.example` to `.env` and fill in credentials locally. Do not commit `.env`.
4. Run `make setup`.
5. Replace the example dlt source and dbt models with your own.

## Local commands

```shell
make setup     # uv + pre-commit
make lint      # Dagster + pre-commit checks
make dev       # Dagster UI without Docker
make serve     # Dagster UI via Docker Compose
make teardown  # stop Docker Compose
```

dbt lives under `transformation/`. Default target is `dev-local` (a local DuckDB file).

```shell
uv run dbt seed --project-dir transformation --profiles-dir transformation --target dev-local
uv run dbt build --project-dir transformation --profiles-dir transformation --target dev-local
```

## Layer conventions

| Folder | Prefix | Role |
| --- | --- | --- |
| `1_staging` | `stg_` | Clean and standardize source data |
| `2_intermediate` | `int_` | Business logic and joins |
| `3_domain` | `dmn_` | Core business entities |
| `4_presentation` | `prs_` | Analysis-ready tables |
| `5_activation` | `act_` | Reverse ETL / activation |
| `6_access` | `acc_` | Copies into attached warehouse databases |

Never run `dbt` with `--full-refresh` in an agent session against shared warehouses.
