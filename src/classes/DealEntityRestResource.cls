@RestResource(urlMapping='/DealEntityController/*')
global class DealEntityRestResource {

@HttpDelete
global static void doDelete(RestRequest req, RestResponse res) {
String s = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
String id = s.substring(s.lastIndexOf('-')+1);
String entityName = s.substring(0, s.lastIndexOf('-'));

if(entityName == 'Account'){
    dealme__DealAccount__c da = [SELECT Id, Name FROM dealme__DealAccount__c WHERE dealme__Account__r.Id = :id];
    delete da;
}
if(entityName == 'TradeIn'){
    dealme__DealTradeIn__c da = [SELECT Id, Name FROM dealme__DealTradeIn__c WHERE dealme__Inventory__r.Id = :id];
    delete da;
}
if(entityName == 'Reference'){
    dealme__DealRefrence__c da = [SELECT Id, Name FROM dealme__DealRefrence__c WHERE dealme__Contact__r.Id = :id];
    delete da;
}
if(entityName == 'Deal'){
    dealme__Deal__c da = [SELECT Id, Name FROM dealme__Deal__c WHERE Id = :id];
    delete da;
}

}

@HttpPost
    global static string updateEntity(Account account) {
        update account;
        return account.id;
}
        

}