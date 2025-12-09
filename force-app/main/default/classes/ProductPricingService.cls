/**
 * @description       : Selector class for all ProductPricing__c object.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class ProductPricingService {
    
    /**
     * @Description Gets pricing information formatted
     * @auther Shahrukh Ahmed
     * @param productId - Product Id
     * @param homeCountry - Home Country of the contact
     * @return List<PricingInfo> - List of pricing information
     */
    public static List<PricingInfo> getPricingForContact(Id productId, String homeCountry) {
        
        List<ProductPricing__c> pricingRecords =
            ProductPricingSelector.selectByProductAndCountry(productId, homeCountry);
        
        // Transform to wrapper class
        List<PricingInfo> pricingInfo = new List<PricingInfo>();
        for (ProductPricing__c record : pricingRecords) {
            pricingInfo.add(new PricingInfo(record));
        }
        
        return pricingInfo;
    }
}