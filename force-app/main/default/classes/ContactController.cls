/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-30-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ContactController {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts()
    {
        return [SELECT Id, FirstName,LastName ,Email FROM Contact WITH SECURITY_ENFORCED ];
        
    }
}