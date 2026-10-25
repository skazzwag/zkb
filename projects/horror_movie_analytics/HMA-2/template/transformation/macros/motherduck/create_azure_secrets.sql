{% macro create_azure_secrets() %}
    {% set parse_only = env_var('DBT_PARSE_ONLY', 'false') | lower == 'true' %}

    {% if target.name in ['dev-local'] or parse_only %}
        {% do log("Skipping Azure secrets creation for target: " ~ target.name ~
            (" (parse-only build)" if parse_only else ""), info=True) %}
        {{ return('') }}
    {% endif %}

    {% set global_connection_string = env_var('AZURE_CONNECTION_STRING_GLOBAL', '') %}
    {% set us_connection_string = env_var('AZURE_CONNECTION_STRING_US', '') %}
    {% set global_ingestion_scope = env_var('AZURE_GLOBAL_INGESTION_SCOPE', '') %}
    {% set global_compaction_scope = env_var('AZURE_GLOBAL_COMPACTION_SCOPE', '') %}
    {% set us_ingestion_scope = env_var('AZURE_US_INGESTION_SCOPE', '') %}
    {% set us_compaction_scope = env_var('AZURE_US_COMPACTION_SCOPE', '') %}

    {% if not global_connection_string %}
        {{ exceptions.raise_compiler_error(
            "AZURE_CONNECTION_STRING_GLOBAL must be set before creating MotherDuck Azure secrets."
        ) }}
    {% endif %}

    {% do log("Creating Azure blob secrets", info=True) %}

    {% if global_ingestion_scope %}
        {% do run_query("
            CREATE OR REPLACE SECRET azure_blob_global_ingestion IN MOTHERDUCK (
                TYPE AZURE,
                CONNECTION_STRING '" ~ global_connection_string ~ "',
                SCOPE '" ~ global_ingestion_scope ~ "'
            )
        ") %}
    {% endif %}

    {% if global_compaction_scope %}
        {% do run_query("
            CREATE OR REPLACE SECRET azure_blob_global_compaction IN MOTHERDUCK (
                TYPE AZURE,
                CONNECTION_STRING '" ~ global_connection_string ~ "',
                SCOPE '" ~ global_compaction_scope ~ "'
            )
        ") %}
    {% endif %}

    {% if us_connection_string and us_ingestion_scope %}
        {% do run_query("
            CREATE OR REPLACE SECRET azure_blob_us_ingestion IN MOTHERDUCK (
                TYPE AZURE,
                CONNECTION_STRING '" ~ us_connection_string ~ "',
                SCOPE '" ~ us_ingestion_scope ~ "'
            )
        ") %}
    {% endif %}

    {% if us_connection_string and us_compaction_scope %}
        {% do run_query("
            CREATE OR REPLACE SECRET azure_blob_us_compaction IN MOTHERDUCK (
                TYPE AZURE,
                CONNECTION_STRING '" ~ us_connection_string ~ "',
                SCOPE '" ~ us_compaction_scope ~ "'
            )
        ") %}
    {% endif %}
{% endmacro %}
