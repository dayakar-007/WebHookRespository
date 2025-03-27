@isTest
public class TestAccountDeletion {
    @isTest public static void testPreventDelete_AccountWithOpportunities()
    {
        Account acc = new Account(name='testaccount');
        insert acc;
        Opportunity opp = new Opportunity(Name=acc.Name + ' Opportunity',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acc.Id);
        insert opp;
        Test.startTest();
            Database.DeleteResult result = Database.delete(acc, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.',
      result.getErrors()[0].getMessage());
    }
    @isTest public static void testAllowDelete_AccountWithoutOpportunities()
    {
        Account acc = new Account(name='testaccount');
        insert acc;
        Test.startTest();
            Database.DeleteResult result = Database.delete(acc, false);
        Test.stopTest();
        System.assert(result.isSuccess(), 'Account deletion failed.');
        System.assert(result.getErrors().size() == 0, 'Account deletion returned errors.');
    }
}