@RestResource(urlMapping='/DealStatusUpdateController/*')
global class DealStatusUpdateController {

@HttpGet
global static Boolean doGet(RestRequest req, RestResponse res) {
String params = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
String newstatus = params.substring(params.lastIndexOf('-')+1);
String dealId = params.substring(0, params.lastIndexOf('-'));

dealme__Deal__c deal = [SELECT Id, Name FROM dealme__Deal__c WHERE Id = :dealId];

if(newstatus == 'TITLE'){
    dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='TITLE' limit 1];
    deal.dealme__DealStatus__c = dealStatus.Id;
    update deal;
}

if(newstatus == 'BHPH'){
    dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='BHPH' limit 1];
    deal.dealme__DealStatus__c = dealStatus.Id;
    update deal;
}

if(newstatus == 'PAIDOFF'){
    dealme__DealStatus__c dealStatus = [Select Id from dealme__DealStatus__c where Name='PAIDOFF' limit 1];
    deal.dealme__DealStatus__c = dealStatus.Id;
    update deal;
}

return true;

}

}