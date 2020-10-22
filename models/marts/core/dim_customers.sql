with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_payments_total
    from orders
    group by 1
),
lifetime_order_value as (
    select 
        customer_id,
        sum(amount) as lifetime_value_balance 
    from orders
    where status in ('shipped','placed','completed')
    group by customer_id
),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_payments_total,
        coalesce(lifetime_order_value.lifetime_value_balance, 0) as lifetime_value_balance
    from customers
    left join customer_orders using (customer_id)
    left join lifetime_order_value using (customer_id)
    where number_of_orders > 0
)
select * from final