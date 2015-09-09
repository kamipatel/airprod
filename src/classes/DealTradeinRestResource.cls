@RestResource(urlMapping='/DealTradeinController/*')
global class DealTradeinRestResource {

@HttpPost
    global static String createDealEntity(dealme__Deal__c deal, dealme__Inventory__c tradeins) {

        insert tradeins;
                
        dealme__DealTradeIn__c da = new dealme__DealTradeIn__c();
        da.dealme__Inventory__c = tradeins.id;
        da.dealme__Deal__c = deal.id;
        insert da;
                
        return tradeins.id;
               
}

}