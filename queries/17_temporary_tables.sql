	--Temporary Table: Executed Trades
	CREATE TABLE #ExecutedTrades
	(
		TradeId INT,
		ClientId INT,
		TradeValue DECIMAL(18,2)
	)

	INSERT INTO #ExecutedTrades
	VALUES (1,1,2857)

	SELECT * FROM #ExecutedTrades

--Temporary Table using SELECT INTO
SELECT 
	ClientId,
	Sum(TradeValue) AS TotalTradeValue
INTO #ClientTradeTotals
FROM Trades
GROUP BY ClientId


SELECT * FROM #ClientTradeTotals


