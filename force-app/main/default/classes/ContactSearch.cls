public with sharing class ContactSearch {
    public static List<Contact> searchForContacts(String lastname,String code)
    {
        
        try {
            List<Contact> conList = [SELECT Id,Name FROM Contact WHERE LastName =: lastname AND MailingPostalCode =: code];
            return conList;
            
        } catch (DmlException e ) {
            return null;
        }
    }
}