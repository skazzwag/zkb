{% macro convert_units(value, input_unit, output_unit) %}
    {%- set distance_units = {
        "millimeters": 0.001,
        "mm": 0.001,
        "meters": 1,
        "m": 1,
        "kilometers": 1000,
        "km": 1000,
        "inches": 0.0254,
        "in": 0.0254,
        "feet": 0.3048,
        "ft": 0.3048,
        "miles": 1609.34,
        "mi": 1609.34
    } -%}

    {%- set volume_units = {
        "m3/h": 1,
        "m3/d": 0.041667,
        "ml/h": 1000,
        "ml/d": 41.6667,
        "l/s": 3.6,
        "g/m": 0.227,
        "g/h": 0.00378541,
        "g/d": 0.000157725,
        "mg/d": 157.725
    } -%}

    {%- if input_unit in distance_units.keys() and output_unit in distance_units.keys() -%}
        {%- set units = distance_units -%}
    {%- elif input_unit in volume_units.keys() and output_unit in volume_units.keys() -%}
        {%- set units = volume_units -%}
    {%- else -%}
        {{ exceptions.raise_compiler_error("Check inputs: Valid units are: Distance (millimeters/mm, meters/m, kilometers/km, inches/in, feet/ft, miles/mi) or Volume (m3/h, m3/d, ml/h, ml/d, l/s, g/m, g/h, g/d, mg/d). You cannot convert from distance -> volume or vice versa.") }}
    {%- endif -%}

    {%- if input_unit == output_unit -%}
        {{ value }}
    {%- else -%}
        {{ value }} * {{ units[input_unit] }} / {{ units[output_unit] }}
    {%- endif -%}
{% endmacro %}
