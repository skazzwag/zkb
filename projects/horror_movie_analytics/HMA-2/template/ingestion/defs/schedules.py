"""Example Dagster jobs and schedules.

Replace these with your warehouse chain (ingestion → dbt → activation).
"""

from __future__ import annotations

import dagster

from ingestion.defs.dbt.config import IS_PROD

DEFAULT_SCHEDULE_STATUS = (
    dagster.DefaultScheduleStatus.RUNNING
    if IS_PROD
    else dagster.DefaultScheduleStatus.STOPPED
)

example_ingestion_job = dagster.define_asset_job(
    name="example_ingestion_job",
    selection=dagster.AssetSelection.groups("example"),
)

dbt_job = dagster.define_asset_job(
    name="dbt_job",
    selection=dagster.AssetSelection.groups("dbt"),
)

example_ingestion_schedule = dagster.ScheduleDefinition(
    name="example_ingestion_schedule",
    job=example_ingestion_job,
    cron_schedule="0 2 * * *",
    execution_timezone="UTC",
    default_status=DEFAULT_SCHEDULE_STATUS,
)
