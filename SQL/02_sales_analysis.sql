-- =====================================================
-- Sales Analysis
-- Table: ecommerce_sales
-- =====================================================

-- =====================================================
# 1. Overall Sales KPI
-- =====================================================

select count(distinct OrderID) as total_orders,
	sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales;

-- =====================================================
# 2. Monthly Sales Trend
-- =====================================================

select YearMonth,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales
from ecommerce_sales
group by YearMonth
order by YearMonth;

-- =====================================================
# 3. Best and Worst Sales Month
-- =====================================================

select YearMonth,
	round(sum(Sales), 2) as total_sales
from ecommerce_sales
group by YearMonth
order by total_sales desc
limit 1;

-- =====================================================
# 4. Lowest Sales Month
-- =====================================================

select YearMonth,
	round(sum(Sales), 2) as total_sales
from ecommerce_sales
group by YearMonth
order by total_sales asc
limit 1;

-- =====================================================
# 5. Yearly Sales Performance
-- =====================================================

select Year,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by Year
order by Year;

-- =====================================================
# 6. Year-over-Year Sales Growth
-- =====================================================

with yearly_sales as(
	select year, sum(Sales) as total_sales
	from ecommerce_sales
    group by Year
)

select Year,
	round(total_sales, 2) as total_sales,
    round(
		(total_sales - LAG(total_sales) over (ORDER BY Year)) 
		/ LAG(total_sales) over (ORDER BY Year) * 100, 2
    ) as yoy_growth_pct
from yearly_sales
ORDER BY Year;

-- =====================================================
# 7. Jan-Jun Year-over-Year Sales Comparison
-- =====================================================

with half_year_sales as(
	select Year, sum(sales) as total_sales
    from ecommerce_sales
    where Month between 1 and 6
    group by Year
)

select Year,
	round(total_sales, 2) as total_sales,
    round(
		(total_sales - lag(total_sales) over (ORDER BY Year))
        / lag(total_sales) over (ORDER BY Year) * 100, 2
	) as yoy_growth_pct
from half_year_sales
ORDER BY Year;

-- =====================================================
# 8. Sales Performance by Category
-- =====================================================

select Category, 
	count(distinct OrderID) as total_orders,
	sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by Category
order by total_sales desc;

-- =====================================================
# 9. Sales Performance by Customer Segment
-- =====================================================

select CustomerSegment,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by CustomerSegment
order by total_sales desc;

-- =====================================================
# 10. Sales Performance by Payment Method
-- =====================================================

select PaymentMethod,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by PaymentMethod
order by total_sales desc;

-- =====================================================
# 11. Sales Performance by Order Status
-- =====================================================

select Status,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by Status
order by total_orders desc;

-- =====================================================
# 12. Sales Performance by City
-- =====================================================

select City,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by City
order by total_sales desc;

-- =====================================================
# 13. Sales Performance by Discount
-- =====================================================

select Discount,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by Discount
order by Discount;


-- =====================================================
# 14. Top 10 Products by Sales
-- =====================================================

select ProductID, ProductName, Category,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by ProductID, ProductName, Category
order by total_sales desc
limit 10;

-- =====================================================
# 15. Top 10 Product by Quantity
-- =====================================================

select ProductID, ProductName, Category,
	count(distinct OrderID) as total_orders,
    sum(Quantity) as total_quantity,
    round(sum(Sales), 2) as total_sales,
    round(avg(OrderValue), 2) as average_order_value
from ecommerce_sales
group by ProductID, ProductName, Category
order by total_quantity desc
limit 10;

-- =====================================================
# 16. Category Performance Ranking
-- =====================================================

select Category,
	count(distinct OrderID) as total_orders,
	round(sum(Sales), 2) as total_sales,
	round(avg(OrderValue), 2) as average_order_value,
	round(sum(Sales) / sum(sum(Sales)) over () * 100, 2
	) as sales_share_pct
from ecommerce_sales
group by Category
order by total_sales desc;














