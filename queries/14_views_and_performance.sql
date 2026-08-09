--View #1 Executed Trades
CREATE VIEW vw_ExecutedTrades AS
SELECT c.client_name,b.BrokerName,s.SecurityName,t.Quantity,t.TradeValue
FROM Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
INNER JOIN Securities as s
	ON s.SecurityID=t.SecurityID
WHERE t.TradeStatus='Executed'

SELECT * FROM vw_ExecutedTrades

--View #2 Settlement Dashboard
CREATE VIEW vw_SettlementDashboard AS 
SELECT SettlementStatus, COUNT(*) AS NumberOfTrades, SUM(SettlementAmount) AS TotalSettlementAmount
FROM Settlements
GROUP By SettlementStatus

SELECT * FROM vw_SettlementDashboard


--Index on TradeStatus
CREATE INDEX IX_Trades_TradeStatus
ON Trades(TradeStatus)

--Index on Trades ClientId
CREATE INDEX IX_Trades_ClientId
ON Trades(ClientId)

--Check Query Performance
SELECT * FROM Trades
WHERE TradeStatus='Executed'



