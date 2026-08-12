--Basic Transaction With Commit
BEGIN TRANSACTION

UPDATE Trades
SET TradeStatus='Executed'
WHERE ClientId=2

COMMIT TRANSACTION

--Basic Transaction With Rollback

BEGIN TRANSACTION

UPDATE Trades
SET TradeStatus='NA'
WHERE ClientId=1

SELECT ClientId,TradeStatus FROM Trades
WHERE ClientId=1

ROLLBACK TRANSACTION

SELECT ClientId,TradeStatus FROM Trades
WHERE ClientId=1


---Transaction With TRY...CATCH
BEGIN TRY

	BEGIN TRANSACTION
	UPDATE Trades
	SET Trdestat='Executed'
	WHERE ClientId=1

	COMMIT TRANSACTION
END TRY

BEGIN CATCH

	IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

	SELECT 
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_MESSAGE() AS Error

END CATCH

---Using XACT_STATE
BEGIN TRY

	BEGIN TRANSACTION
	/***Dynamic SQL forces runtime execution - without that when I ran this It did not go to the 
	CATCH block since it was throwing parse-error**/

	EXEC sp_executesql N'
	UPDATE Trades
	SET Trdestat="Executed"
	WHERE ClientId=1
	'

	COMMIT TRANSACTION

END TRY

BEGIN CATCH

	SELECT 
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_MESSAGE() AS Error,
	XACT_STATE() AS TransactionState  --(0 = No Transaction || 1 = Active, committable || -1 Active, uncommittable (Doomed)

	IF XACT_STATE() <> 0
	   ROLLBACK TRANSACTION

END CATCH
