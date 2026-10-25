from __future__ import annotations

import os
from dataclasses import dataclass


def require_env(name: str) -> str:
    """Return a required environment variable.

    Parameters
    ----------
    name
        Environment variable name.

    Returns
    -------
    str
        The variable value.

    Raises
    ------
    OSError
        If the variable is unset.
    """

    value = os.getenv(name)
    if value is None:
        raise OSError(f"Missing environment variable: {name}")
    return value


@dataclass(frozen=True)
class FilesystemDestinationEnvVars:
    """Filesystem destination credentials for dlt."""

    bucket_url: str
    account_name: str
    account_key: str

    @classmethod
    def load(cls) -> FilesystemDestinationEnvVars:
        """Load destination credentials from the environment."""

        return cls(
            bucket_url=require_env("DESTINATION__FILESYSTEM__BUCKET_URL"),
            account_name=require_env(
                "DESTINATION__FILESYSTEM__CREDENTIALS__AZURE_STORAGE_ACCOUNT_NAME"
            ),
            account_key=require_env(
                "DESTINATION__FILESYSTEM__CREDENTIALS__AZURE_STORAGE_ACCOUNT_KEY"
            ),
        )

    @property
    def credentials(self) -> dict[str, str]:
        """dlt filesystem credential mapping."""

        return {
            "azure_storage_account_name": self.account_name,
            "azure_storage_account_key": self.account_key,
        }
