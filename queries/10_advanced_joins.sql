--Left Join
select * from clients c
left join Trades t
	on c.client_id=t.ClientId

--Right Join
select c.client_name,t.TradeId from clients c
right join Trades t
	on c.client_id=t.ClientId
Where client_name IS NULL

--Full Outer Join
select * from clients c
full outer join Trades t
	on c.client_id=t.ClientId

--Self Join
select b2.BrokerName AS ChildBroker ,b1.BrokerName as ParentBroker  from  Brokers b1
Inner Join Brokers b2
on b1.BrokerName=b2.ParentBrokerId
