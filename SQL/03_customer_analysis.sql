-- =====================================================
-- Customer Analysis
-- Table: ecommerce_sales
-- =====================================================

-- =====================================================
# 1. Customer KPI Summary
-- =====================================================

select
    count(distinct CustomerID) as total_customers,
    count(distinct case when CustomerType = 'Repeat Customer' then CustomerID end) as repeat_customers,
    count(distinct case when CustomerType = 'New Customer' then CustomerID end) as new_customers,
    round(
        count(distinct case when CustomerType = 'Repeat Customer' then CustomerID end)
        / count(distinct CustomerID) * 100, 2
    ) as repeat_customer_share_pct,
    round(
        count(distinct case when CustomerType = 'New Customer' then CustomerID end)
        / count(distinct CustomerID) * 100, 2
    ) as new_customer_share_pct,
    round(sum(Sales) / count(distinct CustomerID), 2) as revenue_per_customer,
    round(count(distinct OrderID) / count(distinct CustomerID), 2) as orders_per_customer,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales;

-- =====================================================
# 2. Customer Overview by Customer Type
-- =====================================================

select
    CustomerType,
    count(distinct CustomerID) as total_customers,
    count(distinct OrderID) as total_orders,
    round(count(distinct OrderID) / count(distinct CustomerID), 2) as orders_per_customer,
    round(sum(Sales), 2) as total_sales,
    round(sum(Sales) / sum(sum(Sales)) over () * 100, 2) as sales_share_pct,
    round(sum(Sales) / count(distinct CustomerID), 2) as revenue_per_customer,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by CustomerType
order by total_sales desc;

-- =====================================================
# 3. Customer Spending Distribution
-- =====================================================

with customer_spending as (
    select
        CustomerID,
        CustomerType,
        count(distinct OrderID) as total_orders,
        round(sum(Sales), 2) as total_sales
    from ecommerce_sales
    group by CustomerID, CustomerType
)

select
    CustomerType,
    count(*) as total_customers,
    round(avg(total_orders), 2) as avg_orders_per_customer,
    round(avg(total_sales), 2) as avg_customer_spending,
    round(min(total_sales), 2) as min_customer_spending,
    round(max(total_sales), 2) as max_customer_spending
from customer_spending
group by CustomerType
order by avg_customer_spending desc;

-- =====================================================
# 4. Top 10 Customers by Sales
-- =====================================================

select
    CustomerID,
    CustomerType,
    CustomerSegment,
    count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by CustomerID, CustomerType, CustomerSegment
order by total_sales desc
limit 10;

-- =====================================================
# 5. Repeat Customer Purchase Frequency
-- =====================================================

with customer_orders as (
    select
        CustomerID,
        count(distinct OrderID) as total_orders
    from ecommerce_sales
    where CustomerType = 'Repeat Customer'
    group by CustomerID
)

select
    total_orders,
    count(*) as customer_count
from customer_orders
group by total_orders
order by total_orders;

-- =====================================================
# 6. Customer Value by Customer Segment
-- =====================================================

select
    CustomerSegment,
    count(distinct CustomerID) as total_customers,
    count(distinct OrderID) as total_orders,
    round(sum(Sales), 2) as total_sales,
    round(sum(Sales) / count(distinct CustomerID), 2) as revenue_per_customer,
    round(count(distinct OrderID) / count(distinct CustomerID), 2) as orders_per_customer,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by CustomerSegment
order by total_sales desc;

-- =====================================================
# 7. Cancellation & Return Rate by Customer Type
-- =====================================================

select
    CustomerType,
    count(distinct OrderID) as total_orders,
    count(distinct case when Status = 'Completed' then OrderID end) as completed_orders,
    count(distinct case when Status = 'Cancelled' then OrderID end) as cancelled_orders,
    count(distinct case when Status = 'Returned' then OrderID end) as returned_orders,
    round(
        count(distinct case when Status = 'Cancelled' then OrderID end)
        / count(distinct OrderID) * 100, 2
    ) as cancellation_rate_pct,
    round(
        count(distinct case when Status = 'Returned' then OrderID end)
        / count(distinct OrderID) * 100, 2
    ) as return_rate_pct
from ecommerce_sales
group by CustomerType
order by CustomerType;

