@IsTest
private class CustomerProductInfoControllerTest {
    @TestSetup
    static void setupData() {
        // Create minimal test data
        Product2 prod =TestDataFactory.createProduct('Test Product');
        insert prod;
        
        Contact con =  TestDataFactory.createContact('12345',prod.Id, 'DE');
        insert con;
        
        ProductPricing__c price = TestDataFactory.createPricingRecord(prod.Id, 'DE', 9.90, 1.7, 6);
        insert price;
    }
    // Test 1: Success with pricing data
    @IsTest
    static void testGetProductPricing_Success() {
        
        Product2 product = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        
        Test.startTest();
        List<PricingInfo> result = CustomerProductInfoController.getProductPricing(product.Id, 'DE');
        Test.stopTest();
        
        Assert.isTrue(!result.isEmpty());
    }
    
    // Test 2: Empty parameters validation
    @IsTest
    static void testEmptyParameters() {
        try {
            CustomerProductInfoController.getProductPricing(null, null);
        } catch (AuraHandledException e) {
            Assert.areEqual(e.getMessage(), 'Product Id and Home Country are required.', 'Expected validation error for empty parameters');
        }
    }
    
    // Test 3: No pricing found
    @IsTest
    static void testNoPricingFound() {
        Product2 product =[SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        
        try {
            CustomerProductInfoController.getProductPricing(product.Id, 'FR');
        } catch (AuraHandledException e) {
            Assert.areEqual(e.getMessage(), 'No pricing information found for the specified product and country.', 'Expected validation error for no pricing found');
        }
    }
}