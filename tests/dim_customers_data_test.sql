-- For our model we are only tracking customers that have ordered at least 1 order and
-- id, and number of orders is an integer value
select customer_id, number_of_orders
    --lifetime_payments_total,
    --lifetime_value_balance
from {{ ref('dim_customers') }}
where ((cast(customer_id as char) like '[0-9]%') AND (cast(number_of_orders as char) like '[0-9]'))
