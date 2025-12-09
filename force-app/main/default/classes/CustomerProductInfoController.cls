/**
 * @description       : controller class for Customer Product Information LWC.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class CustomerProductInfoController {
    
    /**
     * @Description Gets product pricing information for a given product and home country.
     * @auther Shahrukh Ahmed
     * @param productId - Product Id
     * @param homeCountry - Home Country of the contact
     * @return List<PricingInfo> - List of pricing information
     */
    @AuraEnabled(cacheable=true)
    public static List<PricingInfo> getProductPricing(Id productId, String homeCountry) {
        
        try {
            
            if(String.isBlank(productId) || String.isBlank(homeCountry)) {
                throw newAuraException('Product ID and Home Country are required.');
            }
            // Fetch product pricing information
            List<PricingInfo> prodPricingList = ProductPricingService.getPricingForContact(productId, homeCountry);
            
            if (!prodPricingList.isEmpty()) {
                
                return prodPricingList;
                
            } else {
                throw newAuraException('No pricing information found for the specified product and country.');
            }
            
        } catch (Exception e) {
            throw newAuraException('Product Information: ' +e.getMessage());
        }
    }
    
    /**
     * @Description Creates a new AuraHandledException with the given message.
     * @auther Shahrukh Ahmed
     * @param message - Error message
     * @return AuraHandledException - Exception with the provided message
     */
    private static AuraHandledException newAuraException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
}