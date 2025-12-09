/**
 * @description       : Selector class for all Contact object.
 * @author            : Shahrukh Ahmed
 * @company           : N26
 * @last modified on  : 09-12-2025
 * @last modified by  : Shahrukh Ahmed
 **/
public with sharing class ContactSelector {
    
    /**
     * @Description Finds contact by UUID
     * @auther Shahrukh Ahmed
     * @param uuid - External UUID of the contact
     * @return List<Contact> - List of contacts matching the UUID
     */
    public static List<Contact> selectByUuid(String uuid) {
        
        if (String.isBlank(uuid)) {
            return new List<Contact>();
        }
        
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