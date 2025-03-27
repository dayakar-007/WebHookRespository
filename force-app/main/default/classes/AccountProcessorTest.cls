@isTest
public class AccountProcessorTest {
   
    @isTest 
    public static void countNoOfContactsTest()
    {
        Account acc1 = new Account(name='Account1');
        Account acc2 = new Account(name='Account2');
        insert new List<Account>{acc1,acc2};
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc1.Id);
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc1.Id);
        insert new List<Contact>{ contact1, contact2 };
        Test.startTest();
            AccountProcessor.countContacts(new List<Id>{ acc1.Id, acc2.Id });
        Test.stopTest();
        Account account1 = [SELECT number_of_contacts__c FROM account WHERE Id =:acc1.Id];
        Account account2 = [SELECT number_of_contacts__c FROM account WHERE Id =:acc2.Id];
        System.assertEquals(2,account1.number_of_contacts__c);
        System.assertEquals(0,account2.number_of_contacts__c);
        
        

    }
}