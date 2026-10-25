# Data ingestion

This project uses [dlt](https://dlthub.com/) to define pipelines and
[Dagster](https://dagster.io/) to orchestrate them.

## Layout

- `definitions.py` — Dagster loads components from `defs/`
- `defs/` — Dagster components (dlt loads, dbt project, schedules)
- `sources/` — dlt source implementations (`api`, `sql_schema`, `blob_storage`, …)
- `dockerfiles/` — user-code and webserver images

## Local testing

- Start local Dagster stack: `make serve`
- Tear down: `make teardown`
- Lightweight local process (no Docker): `make dev`

## Adding a source

Put extract logic in `ingestion/sources/<kind>/<name>/` and a Dagster
`DltLoadCollectionComponent` under `ingestion/defs/<name>/`. Keep credentials
in environment variables (see `.env.example`); never commit secrets.
