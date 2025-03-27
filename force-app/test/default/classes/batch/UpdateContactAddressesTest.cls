@isTest
public class UpdateContactAddressesTest {

    // Test setup method to insert the required data
    @testSetup
    public static void setUp() {
        // Create and insert a list of 100 Account records
        List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < 1000; i++) {
            Account acc = new Account(Name = 'Account' + i, BillingCity = 'New York', BillingCountry = 'USA');
            accountsToInsert.add(acc);
        }
        insert accountsToInsert;
        System.debug('Insert Succesful');
    
        // Create and insert a list of Contact records related to the Account records
        List<Contact> contactsToInsert = new List<Contact>();
        System.debug('contacts insert started');
        for (Account acc : accountsToInsert) {
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = acc.Id);
            contactsToInsert.add(con);
        }
        upsert contactsToInsert;
    }

    // Test method to verify batch execution and data update
    @isTest
    public static void test() {
        // Start the test
        Test.startTest();

        // Instantiate the batch class
        UpdateContactAddresses uca = new UpdateContactAddresses();
        
        // Execute the batch class
        Id batchId = Database.executeBatch(uca,200); // Set batch size to 200 (or any size that fits your scenario)

        // Wait for asynchronous operations to complete
        Test.stopTest();

        // Verify that the MailingCity of Contacts is updated to 'New York' as per the batch logic
        Integer updatedContactCount = [SELECT COUNT() FROM Contact WHERE MailingCity = 'New York'];
        System.assertEquals(100, updatedContactCount, 'The contacts should have their MailingCity set to New York');
    }
}