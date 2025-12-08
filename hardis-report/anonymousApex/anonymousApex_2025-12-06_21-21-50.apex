// Write your anonymous Apex code here
// Then run it using either:
// - the menu command "Nerdy stuff -> Run anonymous Apex code"
// - the context menu on the file or in this window "Run anonymous Apex code"

List<Product2> prodList = new List<Product2>{
    new Product2(Name = 'Standard', IsActive = true),
    new Product2(Name = 'Black', IsActive = true),
    new Product2(Name = 'Metal', IsActive = false)
};

insert prodList;

List<Contact> conList = new List<Contact>{
    new Contact(FirstName = 'Customer', LastName='1', Home_Country__c = 'DE', Product__c= prodList[0].Id),
    new Contact(FirstName = 'Customer', LastName='2', Home_Country__c = 'FR', Product__c= prodList[1].Id),
    new Contact(FirstName = 'Customer', LastName='3', Home_Country__c = 'UK', Product__c= prodList[2].Id),
    new Contact(FirstName = 'Customer', LastName='4', Home_Country__c = 'IT', Product__c= prodList[0].Id),
    new Contact(FirstName = 'Customer', LastName='5', Home_Country__c = 'ES', Product__c= prodList[1].Id)
};
insert conList;

List<ProductPricing__c> pricList = new List<ProductPricing__c>{
    //Calendar Month
    // Standard
    new ProductPricing__c(Home_Country__c = 'DE',  CalendarMonth__c=0,ATMFee__c=1.7,CardReplacement__c=6, Product__c= prodList[0].Id),
    new ProductPricing__c(Home_Country__c = 'FR',  CalendarMonth__c=0,ATMFee__c=1.7,CardReplacement__c=6, Product__c= prodList[0].Id),
    new ProductPricing__c(Home_Country__c = 'ES',  CalendarMonth__c=0,ATMFee__c=1.7,CardReplacement__c=6, Product__c= prodList[0].Id),
    new ProductPricing__c(Home_Country__c = 'IT',  CalendarMonth__c=0,ATMFee__c=1.7,CardReplacement__c=6, Product__c= prodList[0].Id),
    new ProductPricing__c(Home_Country__c = 'UK',  CalendarMonth__c=0,ATMFee__c=1.7,CardReplacement__c=6, Product__c= prodList[0].Id),
    
    new ProductPricing__c(Home_Country__c = 'DE',  CalendarMonth__c=9.90,ATMFee__c=0,CardReplacement__c=6, Product__c= prodList[1].Id),
    new ProductPricing__c(Home_Country__c = 'FR',  CalendarMonth__c=9.90,ATMFee__c=0,CardReplacement__c=6, Product__c= prodList[1].Id),
    new ProductPricing__c(Home_Country__c = 'ES',  CalendarMonth__c=9.90,ATMFee__c=0,CardReplacement__c=6, Product__c= prodList[1].Id),
    new ProductPricing__c(Home_Country__c = 'IT',  CalendarMonth__c=9.90,ATMFee__c=0,CardReplacement__c=6, Product__c= prodList[1].Id),
    new ProductPricing__c(Home_Country__c = 'UK',ATMFee__c=0,CardReplacement__c=6, Product__c= prodList[1].Id),
    
    new ProductPricing__c(Home_Country__c = 'DE',  CalendarMonth__c=16.90,ATMFee__c=0,CardReplacement__c=45, Product__c= prodList[2].Id),
    new ProductPricing__c(Home_Country__c = 'FR',  CalendarMonth__c=16.90,ATMFee__c=0,CardReplacement__c=45, Product__c= prodList[2].Id),
    new ProductPricing__c(Home_Country__c = 'ES',  CalendarMonth__c=16.90,ATMFee__c=0,CardReplacement__c=45, Product__c= prodList[2].Id),
    new ProductPricing__c(Home_Country__c = 'IT',  CalendarMonth__c=16.90,ATMFee__c=0,CardReplacement__c=45, Product__c= prodList[2].Id),
    new ProductPricing__c(Home_Country__c = 'UK',ATMFee__c=0,CardReplacement__c=45, Product__c= prodList[2].Id)
        
    
};

insert pricList;