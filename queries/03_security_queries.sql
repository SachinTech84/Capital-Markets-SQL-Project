--Basic
select * from Securities
select * from Securities where Exchange='NASDAQ'
select * from Securities where Exchange='NYSE'
select * from Securities where Currency='USD'
select * from Securities order by Ticker

--Aggregate
select count(*) as TotalSecurities from Securities 
select Exchange , count(*) as TotalSecurities from Securities group by Exchange
select Currency , count(*) as TotalSecurities from Securities group by Currency

--Filtering
select * from Securities where Ticker like 'B%'
select * from Securities where SecurityName like '%Bank%'

--Distinct
select DISTINCT Exchange from Securities
select DISTINCT Currency from Securities

--Having
select Exchange,count(*) as TotalSecurities from Securities group by Exchange HAVING count(*)>2
select Currency,count(*) as TotalSecurities from Securities group by Currency HAVING count(*)>1



