# Onboarding

1. Install [uv](https://docs.astral.sh/uv/) and Make.
2. Clone the repo and run `make setup`.
3. Copy `.env.example` to `.env` and fill in local credentials.
4. Read `ingestion/README.md` and `transformation/README.md`.
5. Run the example dbt slice on `dev-local`.
6. Add sources and models using the layer conventions in `.cursor/rules/project.mdc`.
