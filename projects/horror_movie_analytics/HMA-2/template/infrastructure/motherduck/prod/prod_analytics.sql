-- Source of truth for the prod_analytics database.
-- Replace share names, grants, and comments before applying.

create database if not exists prod_analytics;

-- create share if not exists prod_analytics_share from prod_analytics;
-- grant read on share prod_analytics_share to analyst_role;
