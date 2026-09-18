-- =====================================================
-- SQL Data Validation
-- Table: ecommerce_sales
-- =====================================================

-- =====================================================
# 1. Row Count
-- =====================================================

SELECT COUNT(*) AS total_rows 
FROM ecommerce_sales;

-- =====================================================
# 2. Column Count
-- =====================================================

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'ecommerce_sales';

-- =====================================================
# 3. NULL Check
-- =====================================================

SELECT
    SUM(OrderID IS NULL) AS null_orderid,
    SUM(CustomerID IS NULL) AS null_customerid,
    SUM(OrderDate IS NULL) AS null_orderdate,
    SUM(ProductID IS NULL) AS null_productid,
    SUM(Quantity IS NULL) AS null_quantity,
    SUM(Sales IS NULL) AS null_sales,
    SUM(CustomerSegment IS NULL) AS null_customersegment,
    SUM(ProductName IS NULL) AS null_productname,
    SUM(Category IS NULL) AS null_category
FROM ecommerce_sales;

-- =====================================================
# 4. Duplicate OrderID
-- =====================================================

SELECT
    OrderID,
    COUNT(*) AS duplicate_count
FROM ecommerce_sales
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- =====================================================
# 5. Order Date Range
-- =====================================================

SELECT
    MIN(OrderDate) AS first_order_date,
    MAX(OrderDate) AS last_order_date
FROM ecommerce_sales;

-- =====================================================
# 6. Quantity Check
-- =====================================================

SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    ROUND(AVG(Quantity), 2) AS avg_quantity
FROM ecommerce_sales;

-- =====================================================
# 7. Sales Check
-- =====================================================

SELECT
    MIN(Sales) AS min_sales,
    MAX(Sales) AS max_sales,
    ROUND(AVG(Sales), 2) AS avg_sales
FROM ecommerce_sales;

-- =====================================================
# 8. Discount Check
-- =====================================================

SELECT
    MIN(Discount) AS min_discount,
    MAX(Discount) AS max_discount,
    ROUND(AVG(Discount), 4) AS avg_discount
FROM ecommerce_sales;