{% macro limit_data_in_dev(column_name, cutoff_day=3)%}
{#{% if target.name == 'dev'%}#} {#end#}
where {{column_name}} >= dateadd('day', - {{cutoff_day}}, current_timestamp)
{#{% endif %}#}{#end#}
{% endmacro %}