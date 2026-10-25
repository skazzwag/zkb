# MotherDuck infrastructure

SQL in this tree is the source of truth for MotherDuck **databases, shares, and grants**.
Scripts apply on push to `main` via `.github/workflows/motherduck_access.yaml`.
Do not create or delete these objects from ad-hoc MotherDuck sessions.

## Layout: directory is the service account

```
infrastructure/motherduck/
  prod/                 # prod service account → MOTHERDUCK_PROD_TOKEN
    prod_analytics.sql
    prod_operations.sql
  ci/                   # CI service account → MOTHERDUCK_CI_TOKEN
    ci.sql
  hub/
    example/            # customer-facing hub database (optional)
```

- **Folder** = logical grouping of databases.
- **Filename** = database that the script manages.

Replace the example SQL with your organisation's databases, shares, and grants.
