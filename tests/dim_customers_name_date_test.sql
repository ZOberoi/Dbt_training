-- Ensure all dates are in fact in the expected date format only
select first_order_date, most_recent_order_date
from {{ ref('dim_customers') }}
where ((first_order_date like '%[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]%') AND 
(most_recent_order_date like '%[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]%'))