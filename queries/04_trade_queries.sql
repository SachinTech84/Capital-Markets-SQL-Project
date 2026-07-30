
select t.TradeId,c.client_name,t.Quantity,t.Price,t.TradeStatus 
from Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId

select t.TradeId,c.client_name,b.BrokerName,t.Quantity,t.Price 
from Trades t
INNER JOIN Brokers b 
	on b.BrokerID=t.BrokerID
INNER JOIN clients c 
	on c.client_id=t.ClientId

select t.TradeId,c.client_name,b.BrokerName,s.Ticker,s.SecurityName,t.Quantity,t.Price,t.TradeValue,t.TradeStatus 
from Trades t
INNER JOIN Brokers b 
	on b.BrokerID=t.BrokerID
INNER JOIN clients c 
	on c.client_id=t.ClientId
INNER JOIN Securities s 
	on s.SecurityID=t.SecurityID

	
--Executed Trades Report
SELECT t.TradeId,c.client_name,b.BrokerName,s.Ticker,t.Quantity,t.Price,t.TradeValue 
FROM Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId
INNER JOIN Brokers b
	on b.BrokerID=t.BrokerID
INNER JOIN Securities s
	on s.SecurityID=t.SecurityID
WHERE t.TradeStatus='Executed'


--Pending Trades Report
SELECT t.TradeId,c.client_name,b.BrokerName,s.SecurityName,t.TradeStatus 
FROM Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId
INNER JOIN Brokers b
	on b.BrokerID=t.BrokerID
INNER JOIN Securities s
	on s.SecurityID=t.SecurityID
WHERE t.TradeStatus='Pending'


--Highest Value Trade Report
SELECT t.TradeId,c.client_name,b.BrokerName,s.SecurityName,t.TradeStatus, t.TradeValue
FROM Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId
INNER JOIN Brokers b
	on b.BrokerID=t.BrokerID
INNER JOIN Securities s
	on s.SecurityID=t.SecurityID
Order by t.TradeValue DESC

--Total Trade Value by Broker
SELECT b.BrokerName, sum(t.TradeValue) as TotalTradeValue
FROM Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId
INNER JOIN Brokers b
	on b.BrokerID=t.BrokerID
GROUP BY b.BrokerName

--Total Trade Value by Client
SELECT c.client_name, sum(t.TradeValue) as TotalTradeValue
FROM Trades t
INNER JOIN clients c
	on c.client_id=t.ClientId
INNER JOIN Brokers b
	on b.BrokerID=t.BrokerID
GROUP BY c.client_name


