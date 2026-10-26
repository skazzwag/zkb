# Task: DAE: Make notes on handling the out-of-space error I'm getting for dbt pipelines on dagster-user-code azure container app 

**Issue Number:** 1
**Project Code:** DAE-1
**Project:** data_analytics_engineering

**Description:**
The dagster-user-code azure container app has run out of space (provisioned with 20GB of space). This is due to the target folder 
in the dbt project adding new contents every dbt run (i.e. engineer KPIs, non-engineer KPIs, partner API) without clearing old 
run artifacts. This ticket is to add nots on diagnosing the issue and a potential fix for it.

**Created:** 2026-10-26T09:05:00Z
**Author:** skazzwag
**Labels:** dbt Core, dagster

**Link:** No issue raised