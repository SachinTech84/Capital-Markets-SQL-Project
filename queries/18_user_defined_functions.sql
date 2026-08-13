--Scalar Function(Returns One Value): Calculate Trade Fee
CREATE FUNCTION fn_CalculateTradeFee
(
	@TradeValue DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	RETURN @TradeValue * 0.005
END

SELECT dbo.fn_CalculateTradeFee(2000) AS TradeFee

SELECT 
	TradeId,
	TradeValue,
	dbo.fn_CalculateTradeFee(TradeValue) AS TradeFee
FROM Trades

--Net Trade Value
CREATE FUNCTION fn_CalculateNetTradeValue
(
	@TradeValue DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	RETURN @TradeValue - (@TradeValue * 0.005 )
END

SELECT dbo.fn_CalculateNetTradeValue(2000) AS NetTradeValue

SELECT 
	TradeId,
	TradeValue,
	dbo.fn_CalculateNetTradeValue(TradeValue) AS NetTradeValue
FROM Trades


--Table-Valued Function TVF (Returns a result set)
--TVF : Executed Trades By Client
CREATE FUNCTION fn_ExecutedTradesByClient
(
	@ClientID INT
)
RETURNS TABLE
AS
RETURN(
	SELECT
		TradeId,
		ClientId,
		Quantity,
		TradeValue,
		TradeStatus
	FROM Trades
	WHERE ClientId=@ClientID AND TradeStatus='Executed'
)

SELECT * FROM dbo.fn_ExecutedTradesByClient(4)

