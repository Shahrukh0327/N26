/**
 * @description       : Product Information.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
@RestResource(urlMapping='/ProductDetails/*')
global with sharing class ProductDetailRest {
    
    /**
     * @Description REST API to get product details including pricing information based on contact UUIDs.
     * @auther Shahrukh Ahmed
     * @endpoint /services/apexrest/ProductDetails/
     * @method POST
     * @requestBody { "uuids": ["uuid1", "uuid2", ...] }
     * @return Response - Product details along with pricing information
     */
    @HttpPost
    global static void getProductDetails() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Response Response = new Response();
        
        try {
            Request reqObj = (Request) JSON.deserialize(req.requestBody.toString(), Request.class);
            List<String> uuidList = reqObj.uuids;
            
            if (uuidList == null || uuidList.isEmpty()) {
                Response.setError('UUID list cannot be empty', 400);
                sendResponse(Response);
                return;
            }
            
            // Fetch all contacts by UUID
            List<Contact> contacts = ContactSelector.selectByUuid(uuidList);
            
            if (contacts.isEmpty()) {
                Response.setError('No contacts found for provided UUIDs', 404);
                sendResponse(Response);
                return;
            }
            
            Map<String, ProductInfos> prodsResult = new Map<String, ProductInfos>();
            Set<Id> productIds = new Set<Id>();
            Set<String> countries = new Set<String>();
            
            for (Contact c : contacts) {
                
                if (c.Product__c == null || String.isBlank(c.Home_Country__c)) {
                    continue;
                }
                
                String key = c.Product__c + ':' + c.Home_Country__c;
                
                // Adding all uuids having same product and home country in one wrapper
                // Note: This is to avoid multiple json node for same product and country combination
                
                if (!prodsResult.containsKey(key)) {
                    ProductInfos prodInfos = new ProductInfos();
                    prodInfos.uuids = new List<String>();
                    prodsResult.put(key, prodInfos);
                }
                
                prodsResult.get(key).uuids.add(c.External_UUID__c);
                productIds.add(c.Product__c);
                countries.add(c.Home_Country__c);
            }
            
            List<ProductPricing__c> pricingRecords = ProductPricingSelector.selectByProductsAndCountries(productIds, countries);
            
            for (ProductPricing__c p : pricingRecords) {
                
                String key = p.Product__c + ':' + p.Home_Country__c;
                
                // Map pricing records to corresponding product and country in PrioductInfos wrapper
                if (prodsResult.containsKey(key)) {
                    if (prodsResult.get(key).pricing == null) {
                        prodsResult.get(key).pricing = new List<PricingInfo>();
                    }
                    prodsResult.get(key).pricing.add(new PricingInfo(p));
                }
            }
            
            Response.setSuccess('Pricing retrieved successfully', prodsResult.values());
            sendResponse(Response);
            return;
        }
        catch (Exception e) {
            System.debug('REST API Error: ' + e.getMessage() + '\n' + e.getStackTraceString());
            Response.setError('Internal server error', 500);
            sendResponse(Response);
            return;
        }
    }
    /**
     * Pricing informations wrapper which combine the multiple uuids have same product and home country.
     */
    global class ProductInfos {
        public List<String> uuids;
        public List<PricingInfo> pricing;
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
     * REST API request wrapper.
     */
    public class Request {
        public List<String> uuids;
    }
    
    /**
     * REST API response wrapper.
     */
    public with sharing class Response {
        public String statusMessage;
        public Integer statusCode;
        public List<ProductInfos> productDetails;
        
        public void setError(String message,Integer statusCode) {
            this.statusMessage = message;
            this.statusCode = statusCode;
            this.productDetails = null;
        }
        
        public void  setSuccess(String message,List<ProductInfos> productDetails) {
            this.statusMessage = message;
            this.statusCode = 200;
            this.productDetails = productDetails;
        }
    }
}