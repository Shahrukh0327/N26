/**
 * Pricing information Wrapper Class
 * Encapsulates product pricing data
 */
public class PricingInfo {
    @AuraEnabled public String calendarMonth;
    @AuraEnabled public String atmFee;
    @AuraEnabled public String cardReplacement;
    @AuraEnabled public String product;
    @AuraEnabled public Id productId;
    @AuraEnabled public String homeCountry;
    
    public PricingInfo(ProductPricing__c pricing) {
        this.calendarMonth =pricing.CalendarMonth__c!= null ? pricing.Currency_Symbol__c +' '+ pricing.CalendarMonth__c.format() : 'N/A';
        this.atmFee = (pricing.ATMFee__c != null && pricing.ATMFee__c != 0)? pricing.ATMFee__c.format() + '%' : 'Free';
        this.cardReplacement = pricing.CardReplacement__c!= null ? pricing.Currency_Symbol__c+' '+pricing.CardReplacement__c.format() : 'N/A';
        this.product = pricing.Product__r.Name;
        this.productId = pricing.Product__c;
        this.homeCountry = pricing.Home_Country__c;
    }
}