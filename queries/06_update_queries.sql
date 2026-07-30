SELECT * FROM Trades
WHERE TradeStatus='Pending'

UPDATE Trades
SET TradeStatus='Executed' WHERE TradeStatus='Pending'