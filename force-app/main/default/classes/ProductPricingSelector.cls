/**
 * @description       : Selector class for all ProductPricing__c object.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class ProductPricingSelector {
    
    /**
     * @Description Gets pricing information for a contact
     * @auther Shahrukh Ahmed
     * @param productId - Product Id
     * @param homeCountry - Home Country of the contact
     * @return List<ProductPricing__c> - List of pricing information
     */
    public static List<ProductPricing__c> selectByProductAndCountry(Id productId, String homeCountry) {
        
        if (String.isBlank(productId) ||
        String.isBlank(homeCountry)) {
            return new List<ProductPricing__c>();
        }
        List<ProductPricing__c> pricingRecords = [
            SELECT Id, CalendarMonth__c, ATMFee__c, CardReplacement__c, Currency_Symbol__c, Product__r.Name,
                   Product__c, Home_Country__c
            FROM ProductPricing__c 
            WHERE Product__c = :productId 
            AND Home_Country__c = :homeCountry
            WITH USER_MODE
            LIMIT 1000
        ];
        
        return pricingRecords;
    }
    /**
     * @Description Gets pricing information for a contact
     * @auther Shahrukh Ahmed
     * @param productId - Product Ids
     * @param homeCountry - Home Countries of the contacts
     * @return List<ProductPricing__c> - List of pricing information
     */
    public static List<ProductPricing__c> selectByProductsAndCountries(Set<Id> productIds, Set<String> homeCountries) {
        if (productIds == null || homeCountries == null || productIds.isEmpty() || homeCountries.isEmpty()) {
            return new List<ProductPricing__c>();
        }
        
        List<ProductPricing__c> pricingRecords = [
            SELECT Id,
                   CalendarMonth__c,
                   ATMFee__c,
                   CardReplacement__c,
                   Currency_Symbol__c,
                   Product__c,
                   Product__r.Name,
                   Home_Country__c
            FROM ProductPricing__c
            WHERE Product__c IN :productIds
              AND Home_Country__c IN :homeCountries
            WITH USER_MODE
        ];
        
        return pricingRecords;
    }
}