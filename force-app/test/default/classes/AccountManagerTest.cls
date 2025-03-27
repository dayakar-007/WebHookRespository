@isTest
public class AccountManagerTest {
    @testSetup
    public static void setup() {
        // Create and insert a test Account
        Account acc = new Account(Name = 'Dayakar');
        insert acc;
        System.debug('Inserted Account: ' + acc.Id + ' - ' + acc.Name);
        
        // Create and insert test Contacts associated with the Account
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id);
        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc.Id);
        insert con1;
        insert con2;
        System.debug('Inserted Contacts: ' + con1.Id + ' - ' + con1.FirstName + ' ' + con1.LastName + ', ' + con2.Id + ' - ' + con2.FirstName + ' ' + con2.LastName);
    }

    @isTest
    public static void testGetAccountById() {
        // Retrieve the test Account
        Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'Dayakar' LIMIT 1];
        System.debug('Retrieved Test Account: ' + testAcc.Id + ' - ' + testAcc.Name);
        
        // Set the request URI for the mock REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Accounts/' + testAcc.Id + '/contacts';
        RestContext.request = request;
        System.debug('Set Request URI: ' + request.requestURI);

        try {
            // Call the method to test
            Account acc = AccountManager.getAccount();
            System.debug('Retrieved Account from AccountManager.getAccount(): ' + acc.Id + ' - ' + acc.Name);
            
            // Validate the results
            System.assertNotEquals(null, acc, 'The Account should not be null.');
            System.debug('Account is not null.');
            System.assertEquals(testAcc.Id, acc.Id, 'The Account ID does not match the expected value.');
            System.debug('Account ID matches the expected value.');
            System.assertEquals('Dayakar', acc.Name, 'The Account Name does not match the expected value.');
            System.debug('Account Name matches the expected value.');
            System.assertEquals(2, acc.Contacts.size(), 'The number of associated contacts does not match.');
            System.debug('Number of associated contacts matches the expected value.');
            
            // Validate individual contacts
            Set<String> expectedContactNames = new Set<String>{'John Doe', 'Jane Smith'};
            Set<String> actualContactNames = new Set<String>();
            for (Contact contact : acc.Contacts) {
                actualContactNames.add(contact.FirstName + ' ' + contact.LastName);
                System.debug('Retrieved Contact: ' + contact.Id + ' - ' + contact.FirstName + ' ' + contact.LastName);
            }
            System.assertEquals(expectedContactNames, actualContactNames, 'The Contact Names do not match the expected values.');
            System.debug('Contact Names match the expected values.');
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }
}