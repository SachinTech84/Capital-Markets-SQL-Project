---PARTITON BY
WITH BrokerTotals AS
(SELECT b.BrokerID,SUM(t.TradeValue) AS TotalTradeValue,b.BrokerName,b.Country
FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
GROUP BY b.BrokerID,b.BrokerName,b.Country)


SELECT BrokerName,Country,
	ROW_NUMBER() OVER (PARTITION BY Country ORDER By TotalTradeValue DESC) AS CountryWiseRank
FROM BrokerTotals

--RUNNING TOTAL WITH SUM() & OVER()
SELECT TradeId,TradeValue,
	SUM(TradeValue) OVER(ORDER BY TradeId) AS RunningTotal
FROM Trades
ORDER BY TradeId

--LAG()
--Trade-to-trade Change report
SELECT TradeId,TradeValue,
	LAG(TradeValue) OVER (ORDER BY TradeId) AS PreviousTradeValue,
	(TradeValue - LAG(TradeValue) OVER (ORDER BY TradeId)) AS Change
FROM Trades

--LEAD()
--Trade-to-next-Trade Change report
SELECT TradeId,TradeValue,
	LEAD(TradeValue) OVER(ORDER BY TradeId) AS NextTradeValue,
	LEAD(TradeValue) OVER(ORDER BY TradeId) - TradeValue AS TradetoNextTradeChange
FROM Trades
