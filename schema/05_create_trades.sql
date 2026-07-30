CREATE TABLE Trades(
	TradeId INT IDENTITY(1,1) PRIMARY KEY,
	ClientId INT NOT NULL  REFERENCES clients(client_id),
	TradeDate DATETIME2 DEFAULT GETDATE(),
	Quantity INT NOT NULL,
	Price DECIMAL(18,2) NOT NULL,
	TradeStatus VARCHAR(20)NOT NULL,
	TradeValue as (Quantity*Price),
	BrokerID  INT NOT NULL REFERENCES Brokers(BrokerID),
	SecurityID INT NOT NULL REFERENCES Securities(SecurityID)

)
