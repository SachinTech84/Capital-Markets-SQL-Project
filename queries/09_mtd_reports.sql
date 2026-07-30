--MTD Execution Summary report
SELECT TradeStatus, count(*) AS NumberOfTrades, SUM(Quantity) AS TotalQuantity , SUM(TradeValue) as TotalTradeValue 
FROM Trades
WHERE TradeDate BETWEEN DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND GETDATE()
GROUP BY TradeStatus

--Daily Trade Summary report
SELECT TradeDate,count(*) AS Trades,  SUM(Quantity) AS TotalQuantity , SUM(TradeValue) as TotalTradeValue 
FROM Trades
WHERE CAST(TradeDate AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY TradeDate

--Top 5 Clients report
SELECT top 5 c.client_name, SUM(t.TradeValue) as TotalTradeValue 
FROM Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
GROUP BY c.client_name
ORDER BY TotalTradeValue DESC

--Top 5 Brokers report
SELECT top 5 b.BrokerName, SUM(t.TradeValue) as TotalTradeValue 
FROM Trades t
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
GROUP BY b.BrokerName
ORDER BY TotalTradeValue DESC

--Top Securities by Volume
SELECT top 5 se.SecurityName, SUM(t.Quantity) as TotalQuantity 
FROM Trades t
INNER JOIN Securities se
	ON se.SecurityId=t.SecurityId
GROUP BY se.SecurityName
ORDER BY TotalQuantity DESC

--Execution Vs Settlement (Reconciliation report)
SELECT t.TradeId,c.client_name,t.TradeStatus,s.SettlementStatus 
FROM Trades t
INNER JOIN Settlements s
	ON s.TradeId=t.TradeId
INNER JOIN clients c
	ON c.client_id=t.ClientId

--Settlement Dashboard
SELECT SettlementStatus,count(*) AS NumberOfTrades , SUM(SettlementAmount) AS TotalSettlementAmount 
FROM Settlements
GROUP BY SettlementStatus



SELECT c.client_name,
	SUM(CASE WHEN t.TradeStatus='Executed' THEN 1 ELSE 0 END) AS ExecutedTrades,
	SUM(CASE WHEN t.TradeStatus='Pending' THEN 1 ELSE 0 END) AS PendingTrades,
	SUM(CASE WHEN t.TradeStatus='Cancelled' THEN 1 ELSE 0 END) AS CancelledTrades

FROM Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
GROUP BY c.client_name