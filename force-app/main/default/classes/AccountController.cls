/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-14-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountController {
    // @AuraEnabled(cacheable=true)
    // public static List<Account> getAccounts() {
    //     return [
    //         SELECT Id, 
    //                Name, 
    //                NumberOfEmployees, 
    //                Phone, 
    //                OwnerId, 
    //                BillingCity,
    //                CreatedDate
    //         FROM Account
    //     ];
    // }
    // @AuraEnabled(cacheable = true)
    // public static List<Account> getAccoWithCon(){
    //     try {
    //         return [
    //         SELECT Id, Name,NumberOfEmployees, Phone, BillingCity, 
    //             (SELECT Id, Name, Email FROM Contacts) 
    //         FROM Account
    //     ];
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    @AuraEnabled(cacheable=true)
public static Map<String, Object> getAccountsPageSize(Integer pageNumber, Integer pageSize, String searchText) {
    Integer offsetVal = (pageNumber - 1) * pageSize;
    Map<String, Object> response = new Map<String, Object>();

    // Start Debug Logs
    System.debug('🔍 [DEBUG] Fetching Accounts - Page: ' + pageNumber + ', Page Size: ' + pageSize);
    System.debug('🔍 [DEBUG] Search Text Received: ' + searchText);

    // Construct dynamic WHERE clause for search filtering
    String whereClause = 'WHERE Name != NULL';
    Map<String, Object> params = new Map<String, Object>();

    if (String.isNotBlank(searchText)) {
        String searchFilter = '%' + searchText + '%';
        whereClause += ' AND (Name LIKE :searchFilter OR ' +
                       'Phone LIKE :searchFilter OR ' +
                       'BillingCity LIKE :searchFilter OR ' +
                       'Owner.Name LIKE :searchFilter)';
        params.put('searchFilter', searchFilter);
    }

    // Debug whereClause before execution
    System.debug('🔍 [DEBUG] Constructed WHERE Clause: ' + whereClause);

    // Fetch paginated and filtered accounts
    String query = 'SELECT Id, Name, NumberOfEmployees, Phone, Owner.Name, BillingCity, CreatedDate ' +
                   'FROM Account ' + whereClause + 
                   ' ORDER BY Name ASC ' +
                   'LIMIT :pageSize OFFSET :offsetVal';

    System.debug('📜 [DEBUG] Executing Query: ' + query);

    List<Account> accounts = Database.query(query);

    // Fetch total count of records with the same filter
    Integer totalRecords = Database.countQuery('SELECT COUNT() FROM Account ' + whereClause);

    System.debug('📊 [DEBUG] Total Records Matching Search: ' + totalRecords);
    System.debug('✅ [DEBUG] Records Retrieved: ' + accounts.size());

    response.put('accounts', accounts);
    response.put('totalRecords', totalRecords);

    return response;
}


    @AuraEnabled
    public static String  updateAccounts(Object updatedAccounts) {
        System.debug('updatedAccounts: ' + updatedAccounts);
        try {
            System.debug('updatedAccounts: ' + updatedAccounts);
            List<Account> accountsToUpdate = (List<Account>) JSON.deserialize(
                JSON.serialize(updatedAccounts), 
                List<Account>.class);
                update accountsToUpdate;
            return 'done';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}