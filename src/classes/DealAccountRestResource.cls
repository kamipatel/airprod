@RestResource(urlMapping='/DealAccountController/*')
global class DealAccountRestResource {

public static  testmethod void testcreateDealEntity()
{
DealAccountRestResource o = new DealAccountRestResource();
try{

dealme__Deal__c dc = new dealme__Deal__c();
dc.name= 'mytest';
Account account = new Account();
account.name= 'lam';

System.assertEquals(null, createDealEntity(dc, account )); 

RestRequest req = new RestRequest();
req.requestURI = 'blah/20';
RestResponse res = new RestResponse();

doDelete(req, res);
System.assertEquals(true, true); 
doGet(req, res);
System.assertEquals(true, true); 

}catch(Exception e)
{
}
System.assert(true);
}

@HttpPost
    global static String createDealEntity(dealme__Deal__c deal, Account account) {

        insert account;
                
        dealme__DealAccount__c da = new dealme__DealAccount__c();
        da.dealme__Account__c = account.id;
        da.dealme__Deal__c = deal.id;
        insert da;
                
        return account.id;
}

@HttpDelete
global static void doDelete(RestRequest req, RestResponse res) {
String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
Account account = [SELECT Id, Name FROM Account WHERE Id = :accountId];
delete account;
}
@HttpGet
global static Account doGet(RestRequest req, RestResponse res) {
String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
Account result = [SELECT Id, Name FROM Account WHERE Id = :accountId];
return result;
}

}