


CREATE view [dbo].[AccountID_NAME_TYPE_BillingSite]
AS 
(SELECT a.Id, X18_Digit_Account_ID__c, a.Type, a.Site, a.Name , UPPER(X18_Digit_Account_ID__c) Upper_18Digit_ID
FROM [$(DataMgmt_SFDC)].[dbo].Account a)

	

	


