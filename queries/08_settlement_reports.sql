
--Report 1
SELECT T.TradeId,c.client_name,b.BrokerName,s.SecurityName,se.SettlementStatus FROM  Trades t
INNER JOIN clients c
	ON c.client_id=t.ClientId
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerId
INNER JOIN Settlements se
	ON se.TradeId=t.TradeID
INNER JOIN Securities s
	on s.SecurityId=t.SecurityId

--Settlement Summary report
SELECT SettlementStatus AS Status,count(*) as Count 
FROM Settlements
GROUP BY SettlementStatus

--Total Settled Amount report
SELECT SUM(SettlementAmount) AS TotalSettledAmount 
FROM Settlements
WHERE SettlementStatus='Settled'


--Pending Settlements report
SELECT c.client_name,b.BrokerName,s.SecurityName,se.SettlementDate
FROM Settlements se
INNER JOIN Trades t
	ON t.TradeId=se.TradeId
INNER JOIN clients c
	ON c.client_id=t.ClientId
INNER JOIN Securities s
	ON s.SecurityId=t.SecurityId
INNER JOIN Brokers b
	ON b.BrokerID=t.BrokerID
WHERE se.SettlementStatus='Pending'


--Failed Settlement report
SELECT t.TradeId,c.client_name,se.SettlementAmount
FROM Settlements se
INNER JOIN Trades t
	ON t.TradeId=se.TradeId
INNER JOIN clients c
	ON c.client_id=t.ClientId
WHERE se.SettlementStatus='Failed'



