@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        // Get the current request
        RestRequest request = RestContext.request;
        System.debug('RestRequest received: ' + request);
        
        // Extract the account ID from the request URI
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/') - 18,request.requestURI.lastIndexOf('/'));
        System.debug('Extracted Account ID: ' + accId);
        
        // Query the account and its associated contacts
        Account acc = [
            SELECT Id, Name, 
                   (SELECT Id, FirstName, LastName FROM Contacts) 
            FROM Account 
            WHERE Id = :accId
        ];
        System.debug('Queried Account: ' + acc);
        
        return acc;
    }
}