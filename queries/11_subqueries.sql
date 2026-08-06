--High Value Clients
SELECT c.client_name,SUM(t.TradeValue) AS TotalTradeValue 
FROM Trades t
INNER JOIN clients c
ON t.ClientId=c.client_id
GROUP BY c.client_name
HAVING SUM(t.TradeValue) > (
	SELECT AVG(ClientTotal) 
	FROM 
	 (
		SELECT ClientId,SUM(TradeValue) AS ClientTotal FROM Trades
		GROUP BY ClientId
	 ) AS ClientTotals
	
	)
ORDER BY TotalTradeValue DESC


--Above Average Securities
SELECT s.SecurityName ,s.SecurityID,SUM(t.Quantity) AS TotalQuantity 
FROM Trades t
INNER JOIN Securities s
	ON s.SecurityID=t.SecurityID
GROUP BY s.SecurityName,s.SecurityID
HAVING SUM(t.Quantity)  > (
	SELECT AVG(TotalQuantity)
	FROM (
		SELECT SecurityID,SUM(Quantity) AS TotalQuantity 
		FROM Trades 
		GROUP BY SecurityID) AS Totals)
ORDER BY TotalQuantity DESC

--Top Brokers Above Average TradeValue
SELECT b.BrokerName,b.BrokerID, SUM(TradeValue) AS TotalTradeValue 
FROM Trades t
INNER JOIN Brokers b
	ON b.BrokerId=t.BrokerID
GROUP BY b.BrokerName,b.BrokerID
HAVING SUM(TradeValue)  >
 (SELECT AVG(BrokerTradeValue) 
  FROM
	(
		SELECT SUM(TradeValue) AS BrokerTradeValue 
		FROM Trades
		GROUP BY BrokerID
	) AS Totals
	)
ORDER BY TotalTradeValue DESC


--Active Clients
SELECT c.client_name,COUNT(t.TradeId) AS TotalTrades 
FROM Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
GROUP BY c.client_id,c.client_name
HAVING COUNT(t.TradeId)  >
(
	SELECT AVG(TotalTrades)
	FROM (
		SELECT COUNT(TradeId) AS TotalTrades FROM Trades
		GROUP BY ClientId
	) AS ClientTotals

)
ORDER BY TotalTrades DESC

--High Volume Securities
SELECT s.SecurityName ,count(*) AS TotalTrades 
FROM Trades t
INNER JOIN Securities s
	ON s.SecurityID=t.SecurityID
GROUP BY s.SecurityName,s.SecurityID
HAVING count(*)  > (
	SELECT AVG(TotalTrade) 
	FROM
		(
			SELECT COUNT(*) AS TotalTrade 
			FROM Trades
			GROUP BY SecurityID
			) AS Totals
	)

ORDER BY TotalTrades DESC

--Clients Trading More Than Their Own Average (Correlated SubQuery)
SELECT c.client_name,t.TradeId,t.TradeValue ,t.TradeStatus
FROM Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
WHERE t.TradeValue> 
(
	SELECT AVG(t2.TradeValue) FROM Trades t2
	WHERE t2.ClientId=t.ClientId
)
