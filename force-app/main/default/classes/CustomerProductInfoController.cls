public with sharing class CustomerProductInfoController {
    
    @AuraEnabled(cacheable=true)
    public static List<PricingInfo> getProductPricing(Id productId, String homeCountry) {
        try {
            if(String.isBlank(productId) || String.isBlank(homeCountry)) {
                throw newMessageException('Product ID and Home Country are required.');
            }
            List<PricingInfo> prodPricingList = PricingService.getPricingForContact(productId, homeCountry);
            if (!prodPricingList.isEmpty()) {
                return prodPricingList;
            } else {
                throw newMessageException('No pricing information found for the specified product and country.');
            }
        } catch (Exception e) {
            throw newMessageException('Product Information: ' +e.getMessage());
        }
    }
    
    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
}