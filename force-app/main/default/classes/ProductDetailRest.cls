/**
 * @description       : Product Information.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
@RestResource(urlMapping='/ProductDetail/*')
global with sharing class ProductDetailRest {
    
    
    @HttpGet
    global static void getProductDetail(){
        RestRequest req = RestContext.request;
        Response response = new Response();
        try {
            // Extract UUID from the request URI
            String uuId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if (String.isBlank(uuId)) {
                response.setError('UUID cannot be empty', 400);
                sendResponse(response);
                return;
            }
            
            if (!isValidUuid(uuId)) {
                response.setError('Invalid UUID format',400);
                sendResponse(response);
                return;
            }
            
            // Fetch contact by UUID
            List<Contact> contact = ContactSelector.selectByUuid(uuId);
            
            if (contact.isEmpty()) {
                response.setError('Contact not found with UUID: ' + uuId,404);
                sendResponse(response);
                return;
            }
            
            List<PricingInfo> pricingInfo = new List<PricingInfo>();
            // Fetch product pricing details based on contact's product and home country
            pricingInfo = ProductPricingService.getPricingForContact(contact[0].product__c,contact[0].Home_Country__c);
            
            response.setSuccess('Pricing info retrieved successfully',pricingInfo);
            sendResponse(response);
        }
        catch(Exception e){
            System.debug('REST API Error: ' + e.getMessage() + '\n' + e.getStackTraceString());
            response.setError('Internal server error',500);
            sendResponse(response);
        }
        
        
    }
    /**
     * UUID format validation.
     * @param uuid - UUID string to validate
     * @return Boolean - true if valid, false otherwise
     */
    private static Boolean isValidUuid(String uuid) {
        if (String.isBlank(uuid)) return false;
        return uuid.length() >= 10;
    }
    
    /**
     * Sends the REST response.
     * @param res - Response object to send
     */
    private static void sendResponse(Response res) {
        RestResponse restRes = RestContext.response;
        restRes.addHeader('Content-Type', 'application/json');
        restRes.statusCode = res.statusCode;
        restRes.responseBody = Blob.valueOf(JSON.serialize(res));
    }
    
    /**
     * REST API response wrapper.
     */
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