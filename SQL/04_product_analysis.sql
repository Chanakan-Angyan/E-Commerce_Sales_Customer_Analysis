-- =====================================================
-- Product Analysis
-- Table: ecommerce_sales
-- =====================================================

-- =====================================================
-- 1. Top Products by Sales
-- =====================================================

select
    ProductID,
    ProductName,
    Category,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales
from ecommerce_sales
group by ProductID, ProductName, Category
order by total_sales desc
limit 10;

-- =====================================================
-- 2. Top Products by Quantity
-- =====================================================

select
    ProductID,
    ProductName,
    Category,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(sum(Sales) / sum(Quantity), 2) as average_unit_sales
from ecommerce_sales
group by ProductID, ProductName, Category
order by total_quantity desc
limit 10;

-- =====================================================
-- 3. Top Product in Each Category
-- =====================================================

with product_sales as (
    select
        ProductID,
        ProductName,
        Category,
        sum(Quantity) as total_quantity,
        round(sum(Sales), 2) as total_sales
    from ecommerce_sales
    group by ProductID, ProductName, Category
),

ranked_products as (
    select
        ProductID,
        ProductName,
        Category,
        total_quantity,
        total_sales,
        row_number() over (partition by Category order by total_sales desc) as category_rank
    from product_sales
)

select
    ProductID,
    ProductName,
    Category,
    total_quantity,
    total_sales
from ranked_products
where category_rank = 1
order by total_sales desc;

-- =====================================================
-- 4. Top 10 Products Revenue Contribution
-- =====================================================

with product_sales as (
    select
        ProductID,
        ProductName,
        sum(Sales) as total_sales
    from ecommerce_sales
    group by ProductID, ProductName
),

top_10 as (
    select total_sales
    from product_sales
    order by total_sales desc
    limit 10
)

select
    round(sum(total_sales), 2) as top_10_sales,
    round((select sum(Sales) from ecommerce_sales), 2) as total_sales,
    round(
        sum(total_sales) / (select sum(Sales) from ecommerce_sales) * 100, 2
    ) as top_10_sales_share_pct
from top_10;

-- =====================================================
-- 5. Product Average Order Value
-- =====================================================

select
    ProductID,
    ProductName,
    Category,
    count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(sum(Sales) / count(distinct OrderID), 2) as product_aov
from ecommerce_sales
group by ProductID, ProductName, Category
order by product_aov desc
limit 10;

-- =====================================================
-- 6. Product KPI Summary
-- =====================================================

select
    count(distinct ProductID) as total_products,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(sum(Sales) / count(distinct OrderID), 2) as overall_aov,
    round(sum(Sales) / count(distinct ProductID), 2) as average_sales_per_product
from ecommerce_sales;
