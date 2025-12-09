/**
 * Test Data Factory for creating test records
 */
@IsTest(SeeAllData=false)
public class TestDataFactory {
    public static Product2 createProduct(String name) {
        return new Product2(
            Name = name,
        ProductCode = name.replace(' ', '_') + '_001',
        IsActive = true
            );
    }
    
    public static Contact createContact(String uuid, Id productId, String country) {
        return new Contact(
            FirstName = 'Test',
        LastName = 'Customer',
        Email = 'test@example.com',
        External_UUID__c = uuid,
        Product__c = productId,
        Home_Country__c = country
            );
    }
    
    public static ProductPricing__c createPricingRecord(Id productId, String country,Decimal monthlyCost, Decimal atmFee, Decimal cardReplacement) {
        return
            new ProductPricing__c(
            Product__c = productId,
        Home_Country__c = country,
        CalendarMonth__c = monthlyCost,
        ATMFee__c = atmFee,
        CardReplacement__c = cardReplacement
            );
    }
}