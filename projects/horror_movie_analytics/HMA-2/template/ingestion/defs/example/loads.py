import os

import dlt
from dlt.destinations import filesystem as filesystem_destination

from ingestion.sources.api.example.main import example_source

example_posts_source = example_source()

_bucket_url = os.getenv("DESTINATION__FILESYSTEM__BUCKET_URL", "/tmp/dlt-example")
_account_name = os.getenv(
    "DESTINATION__FILESYSTEM__CREDENTIALS__AZURE_STORAGE_ACCOUNT_NAME", ""
)
_account_key = os.getenv(
    "DESTINATION__FILESYSTEM__CREDENTIALS__AZURE_STORAGE_ACCOUNT_KEY", ""
)

if _account_name and _account_key:
    example_posts_pipeline = dlt.pipeline(
        pipeline_name="example_bronze",
        dataset_name="example",
        destination=filesystem_destination(
            bucket_url=_bucket_url,
            credentials={
                "azure_storage_account_name": _account_name,
                "azure_storage_account_key": _account_key,
            },
        ),
    )
else:
    example_posts_pipeline = dlt.pipeline(
        pipeline_name="example_bronze",
        dataset_name="example",
        destination=filesystem_destination(bucket_url=_bucket_url),
    )
