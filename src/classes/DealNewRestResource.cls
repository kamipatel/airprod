@RestResource(urlMapping='/DealNewController/*')
global class DealNewRestResource {

@HttpPost
    global static string createDeal(dealme__Deal__c deal, List<Account> accounts, List<dealme__Inventory__c> tradeIns, List<Contact> contacts, Lead led) {

    if(led != null){
        led.Status = 'Closed - Converted';
        deal.dealme__Lead__c = led.Id;
        update led;
    }

/*
        List<Lead> d = [SELECT Id, Name FROM Lead WHERE Id = :deal.dealme__leadid__c];
        if(d.size() > 0){
            d[0].Status = 'Closed - Converted';
            update d[0];
        } else{
            Lead led = new Lead();
            led.LeadSource = deal.dealme__leadSource__c;
            
            //led.Campaign.Id = deal.dealme__Campaign__c;

            led.Status = 'Closed - Converted';
            insert led ;
            deal.dealme__leadid__c = led.Id;
        }

        deal.dealme__Campaign__c = null;
        deal.dealme__leadSource__c = null;
*/

        if(! deal.dealme__IsQuote__c){    
            dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='FANDI' limit 1];
            deal.dealme__DealStatus__c = dealStatus.Id;
        }else{
            dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='QUOTE' limit 1];
            deal.dealme__DealStatus__c = dealStatus.Id;
        }
        insert deal;
        
        String acccountid = '';
        for (Account c : accounts){
                insert c;
                
                dealme__DealAccount__c da = new dealme__DealAccount__c();
                da.dealme__Account__c = c.id;
                da.dealme__Deal__c = deal.id;
                insert da;
                
                acccountid = c.id;
        }

/*
        system.debug('acccountid is: ' + acccountid);
        system.debug('deal.dealme__leadid__c is: ' + deal.dealme__leadid__c);

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(deal.dealme__leadid__c);        
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
      
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
*/
                
        for (dealme__Inventory__c c : tradeIns){
                c.dealme__status__c = 'NEW';
                c.dealme__Vehicle_Source__c = 'TRADE-IN';
                insert c;
                
                dealme__DealTradeIn__c da = new dealme__DealTradeIn__c();
                da.dealme__Inventory__c = c.id;
                da.dealme__Deal__c = deal.id;
                insert da;
        }

        for (Contact c : contacts){
                insert c;
                
                dealme__DealRefrence__c da = new dealme__DealRefrence__c();
                da.dealme__Contact__c = c.id;
                da.dealme__Deal__c = deal.id;
                insert da;
        }
        
        
        dealme__Inventory__c soldVehicle = [SELECT Id,dealme__Year__c, dealme__VIN__c,Name,dealme__Make__r.Name,dealme__Model__r.Name FROM dealme__Inventory__c WHERE Id = :deal.dealme__Inventory__c];
        soldVehicle.dealme__status__c = 'SOLD';
        update soldVehicle;

//        String xmlContent = getXmlString(deal);
     String xmlContent = '<?xml version="1.0" encoding="UTF-8"?>' +
      '<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">' +
      '<f href="https://na3.salesforce.com/resource/1313761831000/dealme__FL86827KeepInsurance"/>' +
      '<fields>' +
      '<field name="year"><value>' + soldVehicle.dealme__Year__c + '</value></field>' +
      '<field name="vin"><value>' + soldVehicle.dealme__VIN__c + '</value></field>' +
      '<field name="make"><value>' + soldVehicle.dealme__Make__r.Name + '</value></field>' +
      '<field name="model"><value>' + soldVehicle.dealme__Model__r.Name + '</value></field>' +
      '<field name="selldate"><value>' + deal.dealme__soldDate__c + '</value></field>' +
      '</fields>' +      
      '</xfdf>';


        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf(xmlContent);
        attachment.Name = 'KeepInsurance.XFDF';
        attachment.ParentId = deal.id;
       
        insert attachment;

        
        return deal.id;
        
}

 String getXmlString(dealme__Deal__c deal)
 {
     String s = '<?xml version="1.0" encoding="UTF-8"?>' +
      '<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">' +
      '<f href="https://na3.salesforce.com/resource/1313761831000/dealme__FL86827KeepInsurance"/>' +
      '<fields>' +
      '<field name="year"><value>' + '2002' + '</value></field>' +
      '<field name="vin"><value>' + 'VIN20031000' + '</value></field>' +
      '<field name="make"><value>' + 'BMW' + '</value></field>' +
      '<field name="model"><value>' + 'S200' + '</value></field>' +
      '<field name="selldate"><value>' + '08/19/2011' + '</value></field>' +
      '</xfdf>';
                 
     return s;
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