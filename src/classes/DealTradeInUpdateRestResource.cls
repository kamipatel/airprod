@RestResource(urlMapping='/DealTradeInUpdateController/*')
global class DealTradeInUpdateRestResource {

@HttpPost
    global static string updateEntity(dealme__Inventory__c tradeins) {
        update tradeins;
        return tradeins.id;
}
        

}