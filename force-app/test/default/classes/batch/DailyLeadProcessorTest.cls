@isTest
public class DailyLeadProcessorTest {
    
    @testSetup
    public static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead newLead = new Lead(FirstName = 'First' + i, LastName = 'Last' + i, Company = 'Company' + i, Status = 'Open - Not Contacted');
            leads.add(newLead);
        }
        insert leads;
        System.debug('Inserted ' + leads.size() + ' leads in test setup.');
    }

    @isTest
    public static void testCase_1() {
        Test.startTest();
        
        String cronExpression = '0 0 0 1 1 ? 2099';  // Future date to trigger the job immediately in the test context
        String jobId = System.schedule('ScheduledApexTest', cronExpression, new DailyLeadProcessor());
        System.debug('Scheduled job with Id: ' + jobId);
        
        Test.stopTest();
        
        Integer updatedLeads = [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.debug('Number of leads updated: ' + updatedLeads);
        System.assertEquals(200, updatedLeads, 'All leads should have been updated to Dreamforce');
    }
}