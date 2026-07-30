SELECT c.client_name,t.TradeId,t.TradeStatus FROM clients c
LEFT JOIN Trades t
	ON c.client_id=t.ClientID