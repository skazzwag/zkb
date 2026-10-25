"""Example REST source using JSONPlaceholder.

Replace this module with a real source. Keep the same layout:
`ingestion/sources/<kind>/<name>/`.
"""

from __future__ import annotations

import os

import dlt
from dlt.sources.rest_api import RESTAPIConfig, rest_api_resources


@dlt.source(name="example")
def example_source(base_url: str | None = None):
    """Yield a public posts resource.

    Parameters
    ----------
    base_url
        REST API origin. Defaults to ``EXAMPLE_API_BASE_URL`` or JSONPlaceholder.
    """

    config: RESTAPIConfig = {
        "client": {
            "base_url": base_url
            or os.getenv("EXAMPLE_API_BASE_URL", "https://jsonplaceholder.typicode.com"),
        },
        "resource_defaults": {
            "write_disposition": "replace",
        },
        "resources": [
            {
                "name": "posts",
                "endpoint": {
                    "path": "posts",
                },
            }
        ],
    }
    yield from rest_api_resources(config)
