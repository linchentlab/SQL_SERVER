--������ͼ
CREATE VIEW VIEW_INFO
AS
SELECT ACCOUNTINFO.CUSTID,ACCOUNTINFO.CUSTNAME,ACCOUNTINFO.TELEPHONE,CARDINFO.LEFTMONEY,MORTGAGEINFO.BORROWMONEY
FROM ACCOUNTINFO,CARDINFO,MORTGAGEINFO
WHERE ADDRESS = 'USA'