---Basic
select * from Brokers
select * from Brokers where Country='USA'
select * from Brokers where Exchange='NYSE'
select * from Brokers order by BrokerName

--Aggregate
select count(*) as TotalBrokers from Brokers
select Country, count(*) from Brokers group by Country
select Exchange, count(*) from Brokers group by Exchange

--Filtering
select * from Brokers where BrokerName like 'B%'
select * from Brokers where BrokerName like '%Bank%'

--Distinct
select DISTINCT Country from Brokers 
select DISTINCT Exchange from Brokers 

--Having
select Country,count(*) as TotalBroker from Brokers group by Country
HAVING count(*)>1

select Exchange, count(*) as TotalBroker  from Brokers group by Exchange 
HAVING count(*) > 1