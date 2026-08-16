INSERT INTO Trades (ClientId,Quantity,Price,TradeStatus,BrokerID,SecurityID)
VALUES
(1,100,210.50,'Executed',1,1),
(2,50,450.75,'Executed',2,2),
(3,75,185.20,'Pending',3,3),
(4,200,132.10,'Executed',4,4),
(5,120,315.80,'Cancelled',5,5),
(6,80,620.40,'Executed',6,6),
(7,150,148.60,'Pending',7,7),
(8,90,52.25,'Executed',8,8),
(9,110,95.30,'Executed',9,9),
(10,60,720.15,'Pending',10,10)

--Inserting more trades
INSERT INTO Trades (ClientId,Quantity,Price,TradeStatus,BrokerID,SecurityID)
VALUES
(1, 250, 185.40, 'Executed', 2, 3),
(1, 80, 420.75, 'Pending', 4, 5),
(2, 150, 310.20, 'Executed', 3, 4),
(2, 40, 525.50, 'Pending', 5, 6),
(3, 300, 95.60, 'Executed', 1, 7),
(3, 60, 275.30, 'Cancelled', 6, 2),
(4, 90, 650.80, 'Pending', 7, 8),
(4, 175, 225.40, 'Executed', 2, 1),
(5, 200, 180.25, 'Executed', 8, 9),
(5, 50, 740.10, 'Pending', 4, 10),
(6, 125, 450.60, 'Executed', 5, 2),
(6, 300, 115.75, 'Pending', 9, 3),
(7, 70, 820.40, 'Executed', 10, 5),
(7, 220, 165.90, 'Cancelled', 3, 7),
(8, 180, 275.50, 'Executed', 6, 4),
(8, 45, 910.25, 'Pending', 1, 9),
(9, 350, 82.40, 'Executed', 4, 6),
(9, 100, 340.75, 'Pending', 8, 8),
(10, 95, 625.30, 'Executed', 7, 1),
(10, 250, 145.80, 'Pending', 2, 10)