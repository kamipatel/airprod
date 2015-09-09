@RestResource(urlMapping='/DealController/*')
global class DealRestResource {

@HttpPost
    global static string updateDeal(dealme__Deal__c deal) {

         if(! deal.dealme__IsQuote__c){    
            dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='FANDI' limit 1];
            deal.dealme__DealStatus__c = dealStatus.Id;
        }    

        dealme__Deal__c originalDeal = [SELECT Id, Name, dealme__Inventory__c FROM dealme__Deal__c WHERE Id = :deal.Id];
        String originalInventory = originalDeal.dealme__Inventory__c;
        
        if(deal.dealme__Inventory__c != originalInventory){
            dealme__Inventory__c originalVehicle = [SELECT Id,dealme__Year__c, dealme__VIN__c,Name,dealme__Make__r.Name,dealme__Model__r.Name FROM dealme__Inventory__c WHERE Id = :originalInventory];
            originalVehicle.dealme__status__c = 'NEW';
            update originalVehicle;

            dealme__Inventory__c updatedVehicle = [SELECT Id,dealme__Year__c, dealme__VIN__c,Name,dealme__Make__r.Name,dealme__Model__r.Name FROM dealme__Inventory__c WHERE Id = :deal.dealme__Inventory__c];
            updatedVehicle.dealme__status__c = 'SOLD';
            update updatedVehicle;

        }
    
        update deal;
        return deal.id;
}


@HttpDelete
global static void doDelete(RestRequest req, RestResponse res) {
String dealId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
dealme__Deal__c d = [SELECT Id, Name FROM dealme__Deal__c WHERE Id = :dealId];
delete d;
}
@HttpGet
global static Account doGet(RestRequest req, RestResponse res) {
String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
Account result = [SELECT Id, Name FROM Account WHERE Id = :accountId];
return result;
}

}