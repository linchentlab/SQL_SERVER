--����������
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
	
	
	IF @IsLoss = '��'
		BEGIN
			IF @TransType = '֧ȡ'
				BEGIN
					IF @SaveType = '����'
						BEGIN
							IF  @LeftMoney - @TransMoney >= 1
								BEGIN
									INSERT INTO TransInfo VALUES(@CardID,@TransType,@TransMoney,DEFAULT)
									UPDATE CardInfo SET LeftMoney = LeftMoney - @TransMoney WHERE CardID = @CardID
								END
							ELSE
								BEGIN
									PRINT '������� �޷������Ĳ���'
								END
						END
					ELSE
						BEGIN
							ROLLBACK TRANSACTION
							PRINT '��Ĵ�������Ϊ���� ������δ��֮ʱ������ȡǮ'
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
			PRINT '��Ŀ����Ѿ���ʧ'
		END
GO

--���Դ�����
INSERT INTO TransInfo VALUES('1027 3526 1536 1135','֧ȡ',2000,DEFAULT)
INSERT INTO TransInfo VALUES('1029 3326 1536 1235','����',1500,DEFAULT)
INSERT INTO TransInfo VALUES('1324 3626 7532 1935','֧ȡ',1000,DEFAULT)
SELECT * FROM AccountInfo
SELECT * FROM CardInfo
SELECT * FROM TransInfo

