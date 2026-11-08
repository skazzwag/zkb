# Personal analyst workspace (not Git tracked)

Everything under root `analysis/` is intentionally ignored by Git: exploratory
marimo `.py` notebooks, Altair charts, questions, plans, limited approved data
snapshots, outputs and Guide context candidates. Use this for local investigation,
not as a source of production pipeline code or canonical documentation.

Suggested folders: `notebooks/`, `extracts/`, `reports/`, `scratch/`,
`context-candidates/`. Create only what you use. Keep credentials out, avoid raw
sensitive data, and apply the warehouse access rules even though files are ignored.

Ignored files are **not backed up by Git**. Back up valuable work securely using
your approved personal storage. To share/promote a notebook, request a separate,
reviewed move to an agreed *tracked* location outside `analysis/`; do not add a
Git-ignore exception or force-add it without explicit approval.

Verified reusable warehouse definitions should be proposed to the
`analytics-engineer` for a reviewed update to canonical
`transformation/guides/` files. Nothing in this directory is published by CI.

When migrating existing notebooks from `transformation/analysis/`, inspect each
path and its imports rather than moving dbt SQL analysis files by directory name.
