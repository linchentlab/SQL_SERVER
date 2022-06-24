CREATE PROC PROC_INFO
		@CUSTID INT,
		@CUSTNAME VARCHAR(20) OUTPUT,
		@TelePhone VARCHAR(13) OUTPUT,
		@Address VARCHAR(50) OUTPUT,
		@LeftMoney MONEY OUTPUT,
		@BorrowMoney MONEY OUTPUT
AS
BEGIN
SELECT @CUSTID = ACCOUNTINFO.CUSTID,
	@CUSTNAME = ACCOUNTINFO.CUSTNAME,
	@TelePhone = TELEPHONE,
	@Address = ADDRESS,
	@LeftMoney = LEFTMONEY,
	@BorrowMoney = BORROWMONEY 
FROM ACCOUNTINFO INNER JOIN MORTGAGEINFO ON ACCOUNTINFO.CUSTID = MORTGAGEINFO.CUSTID INNER JOIN CARDINFO ON CARDINFO.CUSTID = MORTGAGEINFO.CUSTID
WHERE ACCOUNTINFO.CUSTID = @CUSTID
END


Declare @CUSTID INT,
		@CUSTNAME VARCHAR(20),
		@TelePhone VARCHAR(13),
		@Address VARCHAR(50),
		@LeftMoney MONEY,
		@BorrowMoney MONEY
Set @CUSTID = '1'
Exec PROC_INFO @CUSTID,@CUSTNAME OUTPUT,@TelePhone OUTPUT,@Address OUTPUT,@LeftMoney OUTPUT,@BorrowMoney OUTPUT
Select	@CUSTID '客户ID',@custname '客户姓名',@TelePhone '电话号码',
		@Address '住址',@LeftMoney '信用卡余额',@BorrowMoney '贷款金额'