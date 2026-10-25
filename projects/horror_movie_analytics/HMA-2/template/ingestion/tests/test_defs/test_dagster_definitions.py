from __future__ import annotations

import importlib
import os


def _set_minimal_ingestion_env() -> None:
    """Set env vars so Dagster definitions can load without secrets."""

    os.environ.setdefault(
        "EXAMPLE_API_BASE_URL", "https://jsonplaceholder.typicode.com"
    )
    os.environ.setdefault("DESTINATION__FILESYSTEM__BUCKET_URL", "/tmp/dlt-example")
    os.environ.setdefault("DBT_TARGET", "dev-local")
    os.environ.setdefault("DAGSTER_ENVIRONMENT", "dev")


def test_definitions_load_exposes_example_jobs_and_schedules() -> None:
    """Definitions should load and expose the example job and schedule."""

    _set_minimal_ingestion_env()

    definitions_module = importlib.import_module("ingestion.definitions")
    definitions_obj = definitions_module.definitions()
    repository = definitions_obj.get_repository_def()

    job_names = {job.name for job in repository.get_all_jobs()}
    assert {"example_ingestion_job", "dbt_job"}.issubset(job_names)

    schedule_names = {schedule.name for schedule in repository.schedule_defs}
    assert "example_ingestion_schedule" in schedule_names
