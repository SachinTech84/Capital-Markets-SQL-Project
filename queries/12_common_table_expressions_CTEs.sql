--Client Trade Totals (Basic CTE)
WITH ClientTradeTotals AS 
(SELECT c.client_name,SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_name, c.client_id)

SELECT * 
FROM ClientTradeTotals

--High Value Clients Using CTE
WITH ClientTotals AS 
(
SELECT c.client_name,SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_name,c.client_id
)

SELECT * From 
ClientTotals where TotalTradeValue > 
(SELECT AVG(TotalTradeValue)
FROM ClientTotals)

--Broker Totals Using CTE
WITH BrokerTotals AS
(SELECT b.BrokerName, SUM(TradeValue) AS TotalTradeValue 
FROM Trades t
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
GROUP BY b.BrokerID,b.BrokerName
)

SELECT * 
FROM BrokerTotals


--Multiple CTEs
WITH ClientTradeValue AS 
(SELECT c.client_name,SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_name, c.client_id),
AverageTradeValue AS
(
SELECT AVG(TotalTradeValue) AS AvgTradeValue 
FROM ClientTradeValue
)

SELECT *
FROM ClientTradeValue
WHERE TotalTradeValue > (SELECT AvgTradeValue  FROM AverageTradeValue)


--Rank Brokers By Trade Value (ROW_NUMBER)
WITH BrokerTotals AS
(
SELECT b.BrokerName,SUM(t.TradeValue) AS TotalTradeValue 
FROM 
Trades t
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
GROUP BY b.BrokerID,b.BrokerName
)

SELECT 
	ROW_NUMBER() OVER (ORDER BY TotalTradeValue  DESC) AS ROW_NUMBER,
	BrokerName,TotalTradeValue
FROM BrokerTotals

--Rank Brokers By Trade Value (RANK)
WITH BrokerTotals AS
(
SELECT b.BrokerName,SUM(t.TradeValue) AS TotalTradeValue 
FROM 
Trades t
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
GROUP BY b.BrokerID,b.BrokerName
)

SELECT 
	RANK() OVER (ORDER BY TotalTradeValue  DESC) AS RANK,
	BrokerName,TotalTradeValue
FROM BrokerTotals

--Rank Brokers By Trade Value (DENSE_RANK)

WITH BrokerTotals AS
(
SELECT b.BrokerName,SUM(t.TradeValue) AS TotalTradeValue 
FROM 
Trades t
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
GROUP BY b.BrokerID,b.BrokerName
)

SELECT 
	DENSE_RANK() OVER (ORDER BY TotalTradeValue  DESC) AS DENSE_RANK,
	BrokerName,TotalTradeValue
FROM BrokerTotals

