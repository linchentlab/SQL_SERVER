--����Bank���ݿ�
CREATE DATABASE Bank
   ON PRIMARY                                                
   (
      NAME = 'Bank_data',                                  
      FILENAME = 'C:\�����˻�����ϵͳ\Bank_data.mdf',      
      SIZE = 5MB,                                             
      MAXSIZE = 50MB,                                         
      FILEGROWTH = 100%                                       
   )
   LOG ON                                                       
   (
      NAME = 'Bank_log',                                   
      FILENAME = 'C:\�����˻�����ϵͳ\Bank_log.ldf',       
      SIZE = 1MB,                                             
      FILEGROWTH = 1MB                                        
   )
--�����ͻ���Ϣ��AccountInfo
CREATE TABLE AccountInfo
(
    CustID INT IDENTITY(1,1),                               
    CustName VARCHAR(20) NOT NULL,                          
    IDCard VARCHAR(18) NOT NULL,                            
    TelePhone VARCHAR(13) NOT NULL,                         
    Address VARCHAR(50) DEFAULT('��ַ����') NOT NULL        
)
GO

ALTER TABLE AccountInfo
ADD 
CONSTRAINT PK_CustID PRIMARY KEY (CustID),
CONSTRAINT CK_IDCard CHECK (LEN(IDCard) = 15 OR LEN(IDCard) = 18)
GO

--�������ÿ���Ϣ��CardInfo
CREATE TABLE CardInfo
(
	CardID VARCHAR(19) NOT NULL,                            
	CardPassWord VARCHAR(6) DEFAULT('888888') NOT NULL,   
	CustID INT NOT NULL,                                   
	SaveType VARCHAR(10) NOT NULL,                        
	OpenDate DATETIME DEFAULT(GETDATE()) NOT NULL,         
	OpenMoney MONEY NOT NULL,                               
	LeftMoney MONEY NOT NULL,                               
	IsLoss VARCHAR(2) DEFAULT('��') NOT NULL               
)

ALTER TABLE CardInfo
ADD
CONSTRAINT PK_CardID PRIMARY KEY (CardID),
CONSTRAINT CK_CardID CHECK(LEN(CardID) = 19),
CONSTRAINT CK_CardPassWord CHECK (LEN(CardPassWord) = 6),
CONSTRAINT FK_CustID FOREIGN KEY (CustID) REFERENCES AccountInfo (CustID),
CONSTRAINT CK_SaveType CHECK(SaveType = '����' OR SaveType = '����'),
CONSTRAINT CK_OpenMoney CHECK(OpenMoney >= 1),
CONSTRAINT CK_LeftMoney CHECK(LeftMoney >= 1)


--�������ÿ�������Ϣ��TransInfo
CREATE TABLE TransInfo
(
	CardID VARCHAR(19) NOT NULL,                                
	TransType VARCHAR(4) NOT NULL,                              
	TransMoney MONEY NOT NULL,                                  
	TransDate DATETIME DEFAULT(GETDATE()) NOT NULL             
)


ALTER TABLE TransInfo
ADD
CONSTRAINT FK_CardID FOREIGN KEY (CardID) REFERENCES CardInfo (CardID)


ALTER TABLE TransInfo
ADD
CONSTRAINT CK_TransType CHECK (TransType = '֧ȡ' OR TransType = '����')


--����������Ϣ��
CREATE TABLE MortgageInfo
(
	CardID VARCHAR(19) NOT NULL,                            
	CardPassWord VARCHAR(6) DEFAULT('666666') NOT NULL,   
	CustID INT NOT NULL, 
	BorrowMoney MONEY NOT NULL,                                                        
	BorrowDate DATETIME DEFAULT(GETDATE()) NOT NULL,         
	RepayDate DATETIME,                               
	IsLoss VARCHAR(2) DEFAULT('��')               
)
GO

ALTER TABLE MortgageInfo
ADD
CONSTRAINT PK_CardID1 PRIMARY KEY (CardID),
CONSTRAINT CK_CardID1 CHECK(LEN(CardID) = 19),
CONSTRAINT CK_CardPassWord1 CHECK (LEN(CardPassWord) = 6),
CONSTRAINT FK_CustID1 FOREIGN KEY (CustID) REFERENCES AccountInfo (CustID),
CONSTRAINT CK_IsLoss CHECK(IsLoss = '��' OR IsLoss = '��')
GO

--�����������Ϣ��MortgageTrading
CREATE TABLE MortgageTrading
(
	CardID VARCHAR(19) NOT NULL,                                
	CustID INT NOT NULL,
	BorrowMoney MONEY NOT NULL,                                                        
	BorrowDate DATETIME DEFAULT(GETDATE()) NOT NULL,         
	RepayDate DATETIME   
)

ALTER TABLE MortgageTrading
ADD
CONSTRAINT PK_CardID2 PRIMARY KEY (CardID,CustID),
CONSTRAINT FK_CardID1 FOREIGN KEY (CardID) REFERENCES MortgageInfo (CardID),
CONSTRAINT FK_CardID2 FOREIGN KEY (CustID) REFERENCES AccountInfo (CustID)
