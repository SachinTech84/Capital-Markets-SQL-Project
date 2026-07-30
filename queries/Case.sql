SELECT TradeId,
CASE 
	WHEN  TradeStatus='Executed' THEN 'Completed'
	WHEN  TradeStatus='Pending' OR TradeStatus='Cancelled'  THEN 'Waiting'
END
FROM Trades
