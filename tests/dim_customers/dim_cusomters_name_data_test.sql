select customer_id, first_name, last_name
from {{ ref('dim_customers') }}
where ((first_name like '%[^0-9]%') AND (last_name like '%[^0-9]%'))