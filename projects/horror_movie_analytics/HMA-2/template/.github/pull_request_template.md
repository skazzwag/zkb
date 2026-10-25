## Pull Request Story

<!--- Link to the story in the appropriate tracking tool (e.g. Monday.com) --->

## Description

<!--- Explain goal/motivation of the PR. --->

### Estimated Time to Review

* [ ] Less than 15 mins
* [ ] 15 to 30 mins
* [ ] 30 mins to 1hr
* [ ] 1hr +

## Importance/Risk-level

* [ ] Low
* [ ] Medium
* [ ] High

## Testing and QA

GitHub `run-dbt` is an `--empty` SQL/compile smoke test only. It does **not**
populate data or replace running models and tests against real rows.

* [ ] Column tests added as appropriate for models impacted by this PR
* [ ] Data QA’d against source of truth and golden record tests added.
* [ ] I ran the changed models (and downstreams) **with data** on `dev-local` or `dev-cloud` (not `--empty` only)
* [ ] `dbt test` / `dbt build` passed for those models on this branch
* [ ] Known/expected failures set to warnings as needed (explain new known failures below).
* [ ] I have run pre-commit and fixed any issues that arose.

### dbt run evidence

Required for SQL, seed, or macro changes. `--empty` only is not sufficient.
YAML-only description changes and workflow-only PRs can write `N/A`.

Target: `dev-local` / `dev-cloud`

Command (include `--select` of changed models and downstreams, e.g. `dbt build --select my_model+`):


Output or screenshot:


### dbt test evidence

Required for SQL, seed, macro, or test changes. YAML-only description
changes and workflow-only PRs can write `N/A`.

Command:


Output or screenshot:


## Notes
