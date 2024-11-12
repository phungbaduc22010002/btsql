-- 
SELECT 
    s.StoreID,
    st.StoreName,
    SUM(s.TotalAmount) AS TotalRevenue
FROM 
    Sales s
JOIN 
    Stores st ON s.StoreID = st.StoreID
WHERE 
    QUARTER(s.SaleDate) = QUARTER(CURDATE()) AND
    YEAR(s.SaleDate) = YEAR(CURDATE())
GROUP BY 
    s.StoreID, st.StoreName
ORDER BY 
    TotalRevenue DESC
LIMIT 3; 

-- 
SELECT 
    sd.ProductID,
    p.ProductName,
    (SUM(sd.Quantity * sd.UnitPrice) * 100.0) / 
    (SELECT SUM(sd.Quantity * sd.UnitPrice)
     FROM Sales s
     JOIN SalesDetails sd ON s.SaleID = sd.SaleID
     WHERE s.StoreID = 5 AND YEAR(s.SaleDate) = YEAR(GETDATE()) - 1) AS ContributionPercentage
FROM 
    Sales s
JOIN 
    SalesDetails sd ON s.SaleID = sd.SaleID
JOIN 
    Products p ON sd.ProductID = p.ProductID
WHERE 
    s.StoreID = 5 AND YEAR(s.SaleDate) = YEAR(GETDATE()) - 1
GROUP BY 
    sd.ProductID, p.ProductName;

-- 
SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(s.SaleID) AS NumberOfOrders,
    SUM(s.TotalAmount) AS TotalSpent
FROM 
    Sales s
JOIN 
    Customers c ON s.CustomerID = c.CustomerID
WHERE 
    YEAR(s.SaleDate) = 2024
GROUP BY 
    c.CustomerID, c.CustomerName
HAVING 
    SUM(s.TotalAmount) > 10000
ORDER BY 
    TotalSpent DESC;
