--创建Bank数据库
CREATE DATABASE Bank
   ON PRIMARY                                                
   (
      NAME = 'Bank_data',                                  
      FILENAME = 'C:\银行账户管理系统\Bank_data.mdf',      
      SIZE = 5MB,                                             
      MAXSIZE = 50MB,                                         
      FILEGROWTH = 100%                                       
   )
   LOG ON                                                       
   (
      NAME = 'Bank_log',                                   
      FILENAME = 'C:\银行账户管理系统\Bank_log.ldf',       
      SIZE = 1MB,                                             
      FILEGROWTH = 1MB                                        
   )
--创建客户信息表AccountInfo
CREATE TABLE AccountInfo
(
    CustID INT IDENTITY(1,1),                               
    CustName VARCHAR(20) NOT NULL,                          
    IDCard VARCHAR(18) NOT NULL,                            
    TelePhone VARCHAR(13) NOT NULL,                         
    Address VARCHAR(50) DEFAULT('地址不详') NOT NULL        
)
GO

ALTER TABLE AccountInfo
ADD 
CONSTRAINT PK_CustID PRIMARY KEY (CustID),
CONSTRAINT CK_IDCard CHECK (LEN(IDCard) = 15 OR LEN(IDCard) = 18)
GO

--创建信用卡信息表CardInfo
CREATE TABLE CardInfo
(
	CardID VARCHAR(19) NOT NULL,                            
	CardPassWord VARCHAR(6) DEFAULT('888888') NOT NULL,   
	CustID INT NOT NULL,                                   
	SaveType VARCHAR(10) NOT NULL,                        
	OpenDate DATETIME DEFAULT(GETDATE()) NOT NULL,         
	OpenMoney MONEY NOT NULL,                               
	LeftMoney MONEY NOT NULL,                               
	IsLoss VARCHAR(2) DEFAULT('否') NOT NULL               
)

ALTER TABLE CardInfo
ADD
CONSTRAINT PK_CardID PRIMARY KEY (CardID),
CONSTRAINT CK_CardID CHECK(LEN(CardID) = 19),
CONSTRAINT CK_CardPassWord CHECK (LEN(CardPassWord) = 6),
CONSTRAINT FK_CustID FOREIGN KEY (CustID) REFERENCES AccountInfo (CustID),
CONSTRAINT CK_SaveType CHECK(SaveType = '定期' OR SaveType = '活期'),
CONSTRAINT CK_OpenMoney CHECK(OpenMoney >= 1),
CONSTRAINT CK_LeftMoney CHECK(LeftMoney >= 1)


--创建信用卡交易信息表TransInfo
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
CONSTRAINT CK_TransType CHECK (TransType = '支取' OR TransType = '存入')


--创建贷款信息表
CREATE TABLE MortgageInfo
(
	CardID VARCHAR(19) NOT NULL,                            
	CardPassWord VARCHAR(6) DEFAULT('666666') NOT NULL,   
	CustID INT NOT NULL, 
	BorrowMoney MONEY NOT NULL,                                                        
	BorrowDate DATETIME DEFAULT(GETDATE()) NOT NULL,         
	RepayDate DATETIME,                               
	IsLoss VARCHAR(2) DEFAULT('否')               
)
GO

ALTER TABLE MortgageInfo
ADD
CONSTRAINT PK_CardID1 PRIMARY KEY (CardID),
CONSTRAINT CK_CardID1 CHECK(LEN(CardID) = 19),
CONSTRAINT CK_CardPassWord1 CHECK (LEN(CardPassWord) = 6),
CONSTRAINT FK_CustID1 FOREIGN KEY (CustID) REFERENCES AccountInfo (CustID),
CONSTRAINT CK_IsLoss CHECK(IsLoss = '否' OR IsLoss = '是')
GO

--创建贷款交易信息表MortgageTrading
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
