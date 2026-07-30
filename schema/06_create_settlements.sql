CREATE TABLE Settlements(
	SettlementID INT IDENTITY(1,1) PRIMARY KEY,
	TradeId INT NOT NULL 
		REFERENCES Trades(TradeId),
	SettlementDate DATE NOT NULL,
	SettlementStatus VARCHAR(20) NOT NULL,
	SettlementAmount DECIMAL(18,2) NOT NULL
)