@isTest
private class AccountHandlerTest {

    @isTest
    static void testInsertAccount() {
        System.debug('Starting testInsertAccount method');
        
        Test.startTest();
        System.debug('Test context started');

        // Call the insertAccount method
        System.debug('Calling AccountHandler.insertAccount with name "Test Account"');
        AccountHandler.insertNewAccount('Test Account');
        
        // Query to verify the inserted account
        System.debug('Querying for accounts with name "Test Account"');
        List<Account> accts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        System.debug('Query result: ' + accts);

        // Validate the results
        System.debug('Asserting that one account was inserted');
        System.assertEquals(1, accts.size(), 'Account not inserted');

        Test.stopTest();
        System.debug('Test context stopped');
    }
    
        @isTest
        static void testInsertAccountWithOutName() {
            System.debug('Starting testInsertAccountWithOutName method');
            
            Test.startTest();
            System.debug('Test context started');
    
            // Attempting to insert an account without providing a name
            System.debug('Calling AccountHandler.insertAccount with no parameters');
            Account acc = AccountHandler.insertNewAccount(null);
    
            Test.stopTest();
            System.debug('Test context stopped');
            
            // Validate the result
            System.debug('Asserting that the returned account is null');
            System.assertEquals(null, acc, 'Account should be null when name is not provided');
        }
    
    
}