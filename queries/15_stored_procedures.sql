--Stored Procedure: Get Executed Trades
CREATE PROCEDURE sp_GetExecutedTrades 
AS
BEGIN
	SELECT TradeId,ClientId,BrokerID,SecurityID,Quantity,Price,TradeValue,TradeStatus
	FROM Trades
	WHERE TradeStatus='Executed'
END


EXEC sp_GetExecutedTrades

--Stored Procedure: Get Executed Trades By Client
CREATE PROCEDURE sp_GetExecutedTradesByClient
	@ClientID INT
AS
BEGIN
	SELECT TradeId,ClientId,BrokerID,SecurityID,Quantity,Price,TradeValue,TradeStatus
	FROM Trades
	WHERE TradeStatus='Executed' AND ClientId=@ClientID
END

EXEC sp_GetExecutedTradesByClient 1


--Store Procedure: Get Client Trades By Status
CREATE PROCEDURE sp_GetClientTradesByStatus
	@TradeStatus VARCHAR(20),
	@ClientID INT
AS
BEGIN
	SELECT TradeId,ClientId,BrokerID,SecurityID,Quantity,Price,TradeValue,TradeStatus
	FROM Trades
	WHERE TradeStatus=@TradeStatus AND ClientId=@ClientID
END

EXEC sp_GetClientTradesByStatus 'Executed' , 1

EXEC sp_GetClientTradesByStatus
	@TradeStatus='Executed' ,
	@ClientID=1

--Store Procedure: Get Client Trades By Status (Default Parameter)
CREATE PROCEDURE sp_GetClientTradesByStatus_Defalut
	@ClientID INT,
	@TradeStatus VARCHAR(20) = 'Executed'
AS
BEGIN
	SELECT TradeId,ClientId,BrokerID,SecurityID,Quantity,Price,TradeValue,TradeStatus
	FROM Trades
	WHERE TradeStatus=@TradeStatus AND ClientId=@ClientID
END

EXEC sp_GetClientTradesByStatus_Defalut 1

EXEC sp_GetClientTradesByStatus_Defalut
	 @ClientID=5,
	 @TradeStatus='Cancelled'

--Stored Procedure: Get Client Trade Count (Output Parameter)
CREATE PROCEDURE sp_GetClientTradeCount
	@ClientID INT,
	@TradeCount INT OUTPUT
AS
BEGIN
	SELECT @TradeCount=COUNT(*)
	FROM Trades
	WHERE ClientId=@ClientID
END

----

DECLARE @TotalTrades INT
EXEC sp_GetClientTradeCount
	@ClientID=1,
	@TradeCount=@TotalTrades OUTPUT

SELECT @TotalTrades AS TotalTrades

----		