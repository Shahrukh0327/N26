@IsTest
private class ProductDetailRestTest {
    
    @TestSetup
    static void setupData() {
        
        Product2 prod =TestDataFactory.createProduct('Test Product');
        insert prod;
        
        Contact con1 = TestDataFactory.createContact('UUID1', prod.Id, 'DE');
        Contact con2 = TestDataFactory.createContact('UUID2', prod.Id, 'DE');
        Contact con3 = TestDataFactory.createContact('UUID3', prod.Id, 'DE');
        insert new List<Contact>{ con1, con2, con3 };
        
        ProductPricing__c price = TestDataFactory.createPricingRecord(prod.Id, 'DE', 9.90, 1.7, 6);
        insert price;
    }
    
    @IsTest
    static void testSuccess() {
        List<String> uuids = new List<String>{ 'UUID1', 'UUID2', 'UUID3' };
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetails';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        
        req.requestBody = Blob.valueOf(JSON.serialize(
        new Map<String, Object>{ 'uuids' => uuids }
        ));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetails();
        Test.stopTest();
        
        Assert.areEqual(200, RestContext.response.statusCode, 'Expected 200 status code for successful request');
    }
    
    @IsTest
    static void testNotFound() {
        List<String> uuids = new List<String>{ 'UUID11', 'UUID22', 'UUID33' };
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetails';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        
        req.requestBody = Blob.valueOf(JSON.serialize(
        new Map<String, Object>{ 'uuids' => uuids }
        ));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetails();
        Test.stopTest();
        
        Assert.areEqual(404, RestContext.response.statusCode, 'Expected 404 status code for not found UUIDs');
    }
    
    @IsTest
    static void testEmptyUUID() {
        List<String> uuids = new List<String>();
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/ProductDetails';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        
        req.requestBody = Blob.valueOf(JSON.serialize(
        new Map<String, Object>{ 'uuids' => uuids }
        ));
        
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        ProductDetailRest.getProductDetails();
        Test.stopTest();
        
        Assert.areEqual(400, RestContext.response.statusCode, 'Expected 404 status code for empty UUID');
    }
}