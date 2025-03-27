@isTest
public class LeadProcessorTest {
    
    @testSetup
    public static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead newLead = new Lead(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Company = 'Company' + i,
                Status = 'Open - Not Contacted'
            );
            leads.add(newLead);
        }
        insert leads;
        System.debug('Test setup completed with ' + leads.size() + ' leads inserted');
    }

    @isTest
    public static void test() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Database.executeBatch(lp);
        Test.stopTest();

        Integer updatedLeads = [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.debug('Number of leads updated to Dreamforce: ' + updatedLeads);
        System.assertEquals(200, updatedLeads);
    }
}