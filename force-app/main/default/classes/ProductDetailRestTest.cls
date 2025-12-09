@IsTest
private class ProductDetailRestTest {
    
    @TestSetup
    static void setupData() {
        // Create minimal test data
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;
        
        Contact con =  TestDataFactory.createContact('12345',prod.Id, 'DE');
        insert con;
        
        ProductPricing__c price = TestDataFactory.createPricingRecord(prod.Id, 'DE', 9.90, 1.7, 6);
        insert price;
    }
    
    @IsTest
    static void testSuccess() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetail/12345';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetail();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
    }
    
    @IsTest
    static void testNotFound() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetail/99999';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetail();
        Test.stopTest();
        
        System.assertEquals(404, RestContext.response.statusCode);
    }
    
    @IsTest
    static void testEmptyUUID() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetail/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetail();
        Test.stopTest();
        
        System.assertEquals(400, RestContext.response.statusCode);
    }
}