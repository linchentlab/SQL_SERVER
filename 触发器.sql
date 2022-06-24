--创建触发器
CREATE TRIGGER I_TransInfo_insert
ON TransInfo
	INSTEAD OF INSERT
	AS
	DECLARE @CardID VARCHAR(19)                                                   
	DECLARE @TransMoney MONEY                                                     
	DECLARE @TransType VARCHAR(4)                                                 
	DECLARE @LeftMoney MONEY                                                      
	DECLARE @SaveType VARCHAR(10)                                                 
	DECLARE @IsLoss VARCHAR(2)                                                    
	
	
	SELECT @CardID = CardID FROM INSERTED
	SELECT @TransMoney = TransMoney FROM INSERTED
	SELECT @TransType = TransType FROM INSERTED
	SELECT @SaveType = SaveType FROM CardInfo WHERE CardID = @CardID 
	SELECT @LeftMoney = LeftMoney FROM CardInfo WHERE CardID = @CardID 
	SELECT @IsLoss = IsLoss FROM CardInfo WHERE CardID = @CardID
	
	
	IF @IsLoss = '否'
		BEGIN
			IF @TransType = '支取'
				BEGIN
					IF @SaveType = '活期'
						BEGIN
							IF  @LeftMoney - @TransMoney >= 1
								BEGIN
									INSERT INTO TransInfo VALUES(@CardID,@TransType,@TransMoney,DEFAULT)
									UPDATE CardInfo SET LeftMoney = LeftMoney - @TransMoney WHERE CardID = @CardID
								END
							ELSE
								BEGIN
									PRINT '你的余额不足 无法完成你的操作'
								END
						END
					ELSE
						BEGIN
							ROLLBACK TRANSACTION
							PRINT '你的储蓄类型为定期 在期限未满之时不可以取钱'
						END
				END
			ELSE
				BEGIN
					INSERT INTO TransInfo VALUES(@CardID,@TransType,@TransMoney,DEFAULT)
					UPDATE CardInfo SET LeftMoney = LeftMoney + @TransMoney WHERE CardID = @CardID
				END
		END
	ELSE
		BEGIN
			PRINT '你的卡号已经挂失'
		END
GO

--测试触发器
INSERT INTO TransInfo VALUES('1027 3526 1536 1135','支取',2000,DEFAULT)
INSERT INTO TransInfo VALUES('1029 3326 1536 1235','存入',1500,DEFAULT)
INSERT INTO TransInfo VALUES('1324 3626 7532 1935','支取',1000,DEFAULT)
SELECT * FROM AccountInfo
SELECT * FROM CardInfo
SELECT * FROM TransInfo

