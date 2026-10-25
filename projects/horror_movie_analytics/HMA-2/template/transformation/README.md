# dbt project

Layered dbt Core project targeting DuckDB locally (`dev-local`) and MotherDuck
in cloud environments (`dev-cloud`, `prod`, `ci`).

## Getting started

```shell
make setup
cp .env.example .env   # then fill in values
uv run dbt seed --project-dir transformation --profiles-dir transformation
uv run dbt build --project-dir transformation --profiles-dir transformation
```

## Targets

| Target | Warehouse | Schema |
| --- | --- | --- |
| `dev-local` | `warehouse.duckdb` | `dbt` |
| `dev-cloud` | `md:dev_analytics` | `dbt_{MOTHERDUCK_DEV_USER}` |
| `prod` | `md:prod_analytics` | layer schemas (`dbt_stg`, `dbt_int`, …) |
| `ci` | `md:ci_analytics` | `MOTHERDUCK_CI_SCHEMA` |

Custom schemas apply in `prod` only. Dev and CI build into the target schema
via `generate_schema_name_for_env`.

## Example models

The template ships one vertical slice so `dbt parse` and `dbt build` work
without external data:

`example_events` (seed) → `stg_example_events` → `int_example_events` →
`dmn_events` → `prs_events` → `act_events` → `acc_events`
