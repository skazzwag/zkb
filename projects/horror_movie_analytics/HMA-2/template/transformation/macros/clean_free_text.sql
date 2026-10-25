{% macro clean_free_text(field_name) -%}
    case when {{clean(field_name)}} in (
        'null', 'n/a', 'na', 'none', 'example',
        'test', 'test_material', 'test material'
    )
        then null
        else {{clean(field_name)}}
    end
{%- endmacro %}
