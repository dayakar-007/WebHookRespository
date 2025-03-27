public with sharing class GetAccount {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccount(){
        try {
            List<Account> accList = [SELECT Id,Name,Phone FROM Account LIMIT 10];
            return accList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}