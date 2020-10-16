with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}}
),
payments as (
    select * from {{ ref('stg_payments')}}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value_total
    from orders
    group by 1
),
lifetime_value as (
    select 
        customer_id,
        sum(amount) as lifetime_value_balance 
    from analytics.analytics.orders
    where status in ('shipped','placed','completed')
    group by customer_id
),
lifetime_payments as (
    select
        customer_id,
        sum(amount) as lifetime_payments_total
    from payments
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value_total,
        lifetime_value.lifetime_value_balance,
        lifetime_payments.lifetime_payments_total
    from customers
    left join customer_orders using (customer_id)
    left join lifetime_value using (customer_id)
)
select * from final