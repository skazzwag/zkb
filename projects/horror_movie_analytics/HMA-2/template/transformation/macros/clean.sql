{# Convert empty lists and empty strings to null #}
{% macro clean(field_name) -%}
    case when {{ field_name }} = '[]' then null
         when {{ field_name }} = '' then null
         when typeof({{ field_name }}) in ('VARCHAR', 'TEXT') then lower(trim({{ field_name }}))
         else {{ field_name }}
    end
{%- endmacro %}
