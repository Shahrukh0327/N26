public with sharing class ContactService {
    /**
     * Finds contact by UUID
     */
    public static List<Contact> findByUuid(String uuid) {
        List<Contact> contact = [
            SELECT Id, Name, Product__c, Home_Country__c, 
                    External_UUID__c
            FROM Contact 
            WHERE External_UUID__c = :uuid 
            AND IsDeleted = false
            WITH USER_MODE 
            LIMIT 1
        ];
        
        return contact;
    }
}