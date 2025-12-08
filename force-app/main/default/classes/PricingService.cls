public with sharing class PricingService {
    
    /**
     * Gets pricing information for a contact
     * Caches results to optimize repeated calls
     */
    public static List<PricingInfo> getPricingForContact(Id productId, String homeCountry) {
        // Validate input
        if (String.isBlank(productId) ||
        String.isBlank(homeCountry)) {
            return new List<PricingInfo>();
        }
        // Query pricing data
        List<ProductPricing__c> pricingRecords = [
            SELECT Id, CalendarMonth__c, ATMFee__c, CardReplacement__c, Currency_Symbol__c, ProductPricing__c.Product__r.Name,
                   Product__c, Home_Country__c
            FROM ProductPricing__c 
            WHERE Product__c = :productId 
            AND Home_Country__c = :homeCountry
            LIMIT 100 
        ];
        
        // Convert to DTOs
        List<PricingInfo> pricingInfo = new List<PricingInfo>();
        for (ProductPricing__c record : pricingRecords) {
            pricingInfo.add(new PricingInfo(record));
        }
        
        return pricingInfo;
    }
}