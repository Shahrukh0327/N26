@IsTest
private class CustomerProductInfoControllerTest {
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
    // Test 1: Success with pricing data
    @IsTest
    static void testGetProductPricing_Success() {
        // Create test data using your factory
        Product2 product = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        
        Test.startTest();
        List<PricingInfo> result = CustomerProductInfoController.getProductPricing(product.Id, 'DE');
        Test.stopTest();
        
        System.assert(!result.isEmpty());
    }
    
    // Test 2: Empty parameters validation
    @IsTest
    static void testEmptyParameters() {
        try {
            CustomerProductInfoController.getProductPricing(null, null);
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Product ID and Home Country are required'));
        }
    }
    
    // Test 3: No pricing found
    @IsTest
    static void testNoPricingFound() {
        Product2 product =[SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        
        try {
            CustomerProductInfoController.getProductPricing(product.Id, 'FR');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('No pricing information found'));
        }
    }
    
    // Test 4: Service layer exception
    @IsTest
    static void testServiceException() {
        Product2 product = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        
        // Force exception by making product inactive
        product.IsActive = false;
        update product;
        
        try {
            CustomerProductInfoController.getProductPricing(product.Id, 'DE');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Product Information:'));
        }
    }
}