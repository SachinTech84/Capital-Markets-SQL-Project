USE capital_markets
--Client Trading Summary
SELECT 
	c.client_name,
	COUNT(*) AS NumberOfTrades,
	SUM(t.Quantity) AS TotalQuantity,
	SUM(t.TradeValue) AS TotalTradeValue,
	AVG(t.TradeValue) AS AverageTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_name,c.client_id
HAVING SUM(t.TradeValue) > 0

--Broker Performance Summary
SELECT 
	b.BrokerName,
	COUNT(*) AS NumberOfTrades,
	SUM(t.Quantity) AS TotalQuantity,
	SUM(t.TradeValue) AS TotalTradeValue,
	AVG(t.TradeValue) AS AverageTradeValue
FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
GROUP BY b.BrokerID,b.BrokerName
HAVING SUM(t.TradeValue) > 0

--Security Performance Summary
SELECT 
	s.SecurityName,
	COUNT(*) AS NumberOfTrades,
	SUM(t.Quantity) AS TotalQuantity,
	SUM(t.TradeValue) AS TotalTradeValue,
	AVG(t.TradeValue) AS AverageTradeValue
FROM Trades t
INNER JOIN Securities s
	ON t.SecurityID=s.SecurityID
GROUP BY s.SecurityID,s.SecurityName
HAVING SUM(t.TradeValue) > 0

--Daily Trading Summary
SELECT 
	CAST(TradeDate AS DATE) AS TradeDate, 
	COUNT(*) AS NumberOfTrades,
	SUM(Quantity) AS TotalQuantity,
	SUM(TradeValue) AS TotalTradeValue
FROM Trades
GROUP BY CAST(TradeDate AS DATE)
ORDER BY TradeDate

--Trade Status Summary
SELECT 
	TradeStatus, 
	COUNT(*) AS NumberOfTrades,
	SUM(Quantity) AS TotalQuantity,
	SUM(TradeValue) AS TotalTradeValue,
	AVG(TradeValue) AS AverageTradeValue
FROM Trades
GROUP BY TradeStatus

--Executed vs Pending Trades Summary
SELECT 
	COUNT( CASE WHEN TradeStatus='Executed' THEN 1 END ) AS ExecutedTrades,
	COUNT( CASE WHEN TradeStatus!='Executed' THEN 1 END ) AS NonExecutedTrades,
	SUM( CASE WHEN TradeStatus='Executed' THEN TradeValue END ) AS ExecutedTradeValue,
	SUM( CASE WHEN TradeStatus!='Executed' THEN TradeValue END) AS NonExecutedTradeValue
FROM Trades

--Top 5 Clients By Trade Value
SELECT TOP 5 c.client_name,SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_id,c.client_name
ORDER By TotalTradeValue DESC

--Top 5 Brokers By Trade Value
SELECT TOP 5 b.BrokerName,SUM(TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
GROUP BY b.BrokerID,b.BrokerName
ORDER BY TotalTradeValue DESC

--Top 5 Securities By Trade Volume
SELECT TOP 5 s.SecurityName,SUM(t.Quantity) AS TotalQuantity
FROM Trades t
INNER JOIN Securities s
	On t.SecurityID=s.SecurityID
GROUP BY s.SecurityID, s.SecurityName
ORDER BY TotalQuantity DESC
 

 --Client Trading Activity By Status
 SELECT 
	c.client_name,
	t.TradeStatus,
	COUNT(*) AS NumberOfTrades,
	SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_id,c.client_name,t.TradeStatus

--Monthly Trading Summary
SELECT 
	FORMAT(TradeDate, 'yyyy-MM') AS TradeMonth,
	COUNT(*) AS NumberOfTrades,
	SUM(Quantity) AS TotalQuantity,
	SUM(TradeValue) AS TotalTradeValue
FROM Trades
GROUP BY  FORMAT(TradeDate, 'yyyy-MM')
ORDER By TradeMonth

--Settlement Dashboard Summary
SELECT 
	SettlementStatus,
	COUNT(*) AS NumberOfSettlements,
	SUM(SettlementAmount) AS TotalSettlementAmount,
	AVG(SettlementAmount) AS AverageSettlementAmount
FROM Settlements
GROUP BY SettlementStatus

--Final MTD Execution Dashboard
SELECT 
	COUNT( CASE WHEN TradeStatus='Executed' THEN 1 END) AS ExecutedTrades,
	COUNT( CASE WHEN TradeStatus!='Executed' THEN 1 END) AS NonExecutedTrades,
	SUM( CASE WHEN TradeStatus='Executed' THEN Quantity END) AS ExecutedQuantity,
	SUM( CASE WHEN TradeStatus!='Executed' THEN Quantity END) AS NonExecutedQuantity,
	SUM( CASE WHEN TradeStatus='Executed' THEN TradeValue END) AS ExecutedTradeValue,
	SUM( CASE WHEN TradeStatus!='Executed' THEN TradeValue END) AS NonExecutedTradeValue
FROM Trades
WHERE TradeDate>= DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1)

--Trade-to-Trade Analysis
SELECT 
	TradeId,
	TradeValue,
	LAG(TradeValue) OVER(ORDER BY TradeId) AS PreviousTradeValue,
	TradeValue - LAG(TradeValue) OVER(ORDER BY TradeId ) AS ChangeFromPreviousTrade
FROM Trades


--Each Client's Highest-Value Trade
WITH RankedTrades AS (
SELECT 
	c.client_name,
	t.TradeId,
	t.TradeValue,
	ROW_NUMBER() OVER(PARTITION BY c.client_id ORDER BY TradeValue DESC) AS RowNum
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
)

SELECT 
	client_name,
	TradeId,
	TradeValue 
FROM RankedTrades 
WHERE RowNum=1

--Clients Whose Total Trade Value Is Greater Than The Average Total Trade Value Across All Clients
WITH ClientTotals AS (
SELECT 
	c.client_name,
	SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_id,c.client_name
)

SELECT 
	client_name,
	TotalTradeValue
FROM ClientTotals
WHERE TotalTradeValue > (
	SELECT AVG(TotalTradeValue) FROM
	ClientTotals
)

--Ranking Within Groups
WITH RankedBrokers AS (
SELECT 
	b.BrokerName,
	t.TradeId,
	t.TradeValue,
	ROW_NUMBER() OVER(PARTITION BY b.BrokerID ORDER BY t.TradeValue DESC) AS RowNum	
FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
)

SELECT 
	BrokerName,
	TradeId,
	TradeValue 
FROM RankedBrokers
WHERE RowNum=1

--Running Total Of Trade Value Ordered By TradeId
SELECT 
	TradeId,
	TradeValue,
	SUM(TradeValue) OVER(ORDER BY TradeId) RunningTotal
FROM Trades

--Previous Vs Current Trade
WITH TradeWithPrevious AS (
SELECT 
	TradeId,
	TradeValue,
	LAG(TradeValue) OVER(ORDER BY TradeId) AS PreviousTradeValue
FROM Trades
)

SELECT 
	TradeId,
	TradeValue,
	PreviousTradeValue,
	(CASE
		WHEN PreviousTradeValue IS NULL OR PreviousTradeValue = 0
			THEN NULL
		ELSE
			CAST(((TradeValue - PreviousTradeValue)/(PreviousTradeValue)*100) AS DECIMAL(18,2)) 
	END) AS PercentageChange
FROM TradeWithPrevious


--Above Client Average Trades
--Trades Whose Trade Value Is Greater Than That Client's Own Average Trade Value
WITH ClientsAvgTradeValue AS (
SELECT 
	c.client_name,
	c.client_id,
	AVG(t.TradeValue) AS ClientAverageTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP BY c.client_id,c.client_name
)


SELECT 
	t.TradeId,
	c.client_name,
	t.TradeValue,
	c.ClientAverageTradeValue
FROM Trades t
JOIN ClientsAvgTradeValue c
	ON t.ClientId=c.client_id
WHERE t.TradeValue> c.ClientAverageTradeValue


--Broker Country Ranking
WITH BrokersTotals AS (
SELECT 
	b.Country,
	b.BrokerID,
	b.BrokerName,
	SUM(t.TradeValue) AS TotalTradeValue
FROM Trades t
INNER JOIN Brokers b
	ON t.BrokerID=b.BrokerID
GROUP BY b.BrokerID,b.BrokerName,b.Country
)


SELECT 
	Country,
	BrokerName,
	TotalTradeValue,
	RANK() OVER(PARTITION BY Country ORDER BY TotalTradeValue DESC) AS CountryRank
FROM BrokersTotals
	

--Trade Status Pivot
SELECT 
	c.client_name,
	COUNT(CASE WHEN t.TradeStatus='Executed' THEN 1 END) AS ExecutedTrades,
	COUNT(CASE WHEN t.TradeStatus!='Executed'THEN 1 END) AS NonExecutedTrades,
	SUM(CASE WHEN t.TradeStatus='Executed' THEN t.TradeValue END) AS ExecutedTradeValue,
	SUM(CASE WHEN t.TradeStatus!='Executed' THEN t.TradeValue END) AS NonExecutedTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
GROUP By c.client_name,c.client_id

--Latest Trade Per Client
WITH ClientTradeDateRank AS (
SELECT 
	c.client_name,
	t.TradeId,
	t.TradeDate,
	t.TradeValue,
	ROW_NUMBER() OVER (PARTITION BY c.client_id ORDER BY t.TradeDate DESC) AS RowNum
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
)

SELECT 
	client_name,
	TradeId,
	TradeDate,
	TradeValue 
FROM ClientTradeDateRank
WHERE RowNum=1

--Clients With No Trades
SELECT 
	c.client_id,
	c.client_name
FROM clients c
LEFT JOIN Trades t
	On c.client_id=t.ClientId
WHERE t.TradeId IS NULL


--Trade Value Classification
SELECT 
	TradeId,
	TradeValue,
	(CASE
		WHEN TradeValue>=30000 
			THEN 'HIGH' 
		WHEN TradeValue >=15000
			THEN 'MEDIUM'
		ELSE
			 'LOW'
	END)
	AS TradeCategory  --These Are Business-defined Thresholds Subject To Change
FROM Trades

--Settlement Reconciliation
SELECT 
	t.TradeId,
	t.TradeValue,
	s.SettlementAmount,
	(t.TradeValue -s.SettlementAmount) AS Difference
FROM Trades t
INNER JOIN Settlements s
	ON t.TradeId=s.TradeId
WHERE t.TradeValue<> s.SettlementAmount


--Top 3 Clients By Executed Trade Value Within Each Broker
WITH Totals AS(
SELECT 
	b.BrokerName,
	c.client_name,
	SUM(t.TradeValue) AS TotalExecutedTradeValue
FROM Trades t
INNER JOIN clients c
	ON t.ClientId=c.client_id
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
WHERE t.TradeStatus='Executed'
GROUP BY b.BrokerName,c.client_name

),
RankedBrokers AS (
SELECT 
	BrokerName,
	client_name,
	TotalExecutedTradeValue,
	RANK() OVER (PARTITION BY BrokerName ORDER BY TotalExecutedTradeValue DESC) AS Ranking
FROM Totals 
)

SELECT 
	BrokerName,
	client_name,
	TotalExecutedTradeValue,
	Ranking
FROM RankedBrokers where Ranking<=3
