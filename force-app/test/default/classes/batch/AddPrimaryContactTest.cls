@isTest
public class AddPrimaryContactTest {
    
    @testSetup
    public static void setUp() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            Account acc = new Account(Name = 'TestNY' + i, BillingState = 'NY');
            accounts.add(acc);
        }
        for (Integer i = 0; i < 50; i++) {
            Account acc = new Account(Name = 'TestCA' + i, BillingState = 'CA');
            accounts.add(acc);
        }
        insert accounts;
        System.debug('Inserted ' + accounts.size() + ' accounts in test setup.');
    }

    @isTest
    public static void testAddPrimaryContactForCA() {
        Contact sampleContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com');
        System.debug('Sample contact to be cloned: ' + sampleContact);

        Test.startTest();
        AddPrimaryContact apc = new AddPrimaryContact(sampleContact, 'CA');
        System.debug('Enqueuing AddPrimaryContact job with state abbreviation: CA');
        System.enqueueJob(apc);
        Test.stopTest();

        Integer contactsCount = [SELECT count() FROM Contact WHERE Email = 'johndoe@example.com'];
        System.debug('Number of contacts inserted for state CA: ' + contactsCount);
        System.assertEquals(50, contactsCount);
    }
    @IsTest
    public static void testAddPrimaryContactForNoAccounts()
    {
        Contact sampleContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'johndoe@example.com');
        System.debug('Sample contact to be cloned: ' + sampleContact);

        Test.startTest();
        AddPrimaryContact apc = new AddPrimaryContact(sampleContact, 'PA');
        System.debug('Enqueuing AddPrimaryContact job with state abbreviation: PA ');
        System.enqueueJob(apc);
        Test.stopTest();

        Integer contactsCount = [SELECT count() FROM Contact WHERE Email = 'johndoe@example.com'];
        System.debug('Number of contacts inserted for state CA: ' + contactsCount);
        System.assertEquals(0, contactsCount);
    }

}