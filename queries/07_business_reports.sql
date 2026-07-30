--Report 1
SELECT TradeStatus,COUNT(*) AS NumberOfTrades FROM Trades
GROUP BY TradeStatus

--Report 2
SELECT b.BrokerName, count(*) AS TotalTrades FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
GROUP BY BrokerName

--Report 3
SELECT s.SecurityName,SUM(t.Quantity) AS TotalQuantityTraded FROM Trades t
INNER JOIN Securities s
	ON t.SecurityId=s.SecurityID
GROUP BY s.SecurityName


--Report 4
SELECT c.client_name,SUM(t.TradeValue) AS TotalTradeValue FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_name

--Report 5
SELECT b.BrokerName,COUNT(*) AS ExecutedTrades FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
WHERE t.TradeStatus='Executed'
GROUP BY b.BrokerName


