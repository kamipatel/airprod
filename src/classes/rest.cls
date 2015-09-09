public global with sharing class rest {

    public String apiServerURL { get; set; }

    public String getApiServerURL() {
        return null;
    }


    public String apiSessionId { get; set; }

    public PageReference doLogin() {
        return null;
    }


    private PageReference page;
    private string action;
    private string session;
    private string result;

    public rest() {
        //constructor, let's grab the session token here
        session = userInfo.getSessionId();
 
        page = ApexPages.currentPage();
        this.action = page.getParameters().get('action');
        if (action == null) action = '';
 
        integer q = action.indexOf('query/?q=');
 
        if(q >= 0) {
            string qs = action.substring(q + 9);
            action = action.substring(0, q + 9);
 
            action += EncodingUtil.urlEncode(qs, 'UTF-8');
        }
    }


    public String getResult() {
        return this.result;
    }

    
    public void retrieve() {
        //we'll call the REST API here
        http h = new http();
 
        httprequest req = new httprequest();
        //note that 'na1' may be different for your organization
        req.setEndpoint('https://na3.salesforce.com/services/data/v21.0/sobjects/dealme__Inventory__c');
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + session);
        req.setTimeout(60000);
 
        httpresponse res = h.send(req);
 
        result = res.getBody();
    }


}