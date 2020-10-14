with orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status
        --analytics.analytics.orders amount
    from raw.jaffle_shop.orders
    --join analytics.analytics.orders using (customer_id)

)
select * from orders