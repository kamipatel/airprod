@RestResource(urlMapping='/DealReferenceController/*')
global class DealReferenceRestResource {

@HttpPost
    global static String createDealEntity(dealme__Deal__c deal, Contact reference) {

        insert reference;
                
        dealme__DealRefrence__c da = new dealme__DealRefrence__c();
        da.dealme__Contact__c = reference.id;
        da.dealme__Deal__c = deal.id;
        insert da;
                
        return da.id;
               
}

}