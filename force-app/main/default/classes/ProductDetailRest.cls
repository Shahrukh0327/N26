@RestResource(urlMapping='/ProductDetail/*')
global with sharing class ProductDetailRest {
    
    
    @HttpGet
    global static void getProductDetail(){
        RestRequest req = RestContext.request;
        Response response = new Response();
        try {
            
            String uuId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if (String.isBlank(uuId)) {
                response.setError('UUID cannot be empty', 400);
                sendResponse(response);
                return;
            }
            // Find Contact by UUID
            List<Contact> contact = ContactService.findByUuid(uuId);
            
            if (contact.isEmpty()) {
                // Not Found
                response.setError('Contact not found with UUID: ' + uuId,404);
                sendResponse(response);
                return;
            }
            
            // Get pricing info
            List<PricingInfo> pricingInfo = new List<PricingInfo>();
            pricingInfo = PricingService.getPricingForContact(contact[0].product__c,contact[0].Home_Country__c);
            
            if (pricingInfo.isEmpty()) {
                response.setError('No pricing info found for this contact', 404);
                sendResponse(response);
                return;
            }
            
            response.setSuccess('Pricing info retrieved successfully',pricingInfo);
            
        }
        catch(Exception e){
            response.setError('Internal server error: ' + e.getMessage(),500);
        }
        
        sendResponse(response);
    }
    
    private static void sendResponse(Response res) {
        RestResponse restRes = RestContext.response;
        restRes.addHeader('Content-Type', 'application/json');
        restRes.statusCode = res.statusCode;
        restRes.responseBody = Blob.valueOf(JSON.serialize(res));
    }
    
    public with sharing class Response {
        public String statusMessage;
        public Integer statusCode;
        public List<PricingInfo> productPricing;
        
        public void setError(String message,Integer statusCode) {
            this.statusMessage = message;
            this.statusCode = statusCode;
            this.productPricing = null;
        }
        
        public void  setSuccess(String message,List<PricingInfo> productPricing) {
            this.statusMessage = message;
            this.statusCode = 200;
            this.productPricing = productPricing;
        }
    }
}