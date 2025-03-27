public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        System.debug('DailyLeadProcessor scheduled job started.');
        
        // Find the first 200 Leads with a blank LeadSource field
        List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = NULL LIMIT 200];
        System.debug('Number of leads retrieved: ' + leads.size());

        // Update the LeadSource field to 'Dreamforce' for each Lead
        for (Lead lead : leads) {
            lead.LeadSource = 'Dreamforce';
            
        }
        
        // Update the Lead records in the database
        if (!leads.isEmpty()) {
            update leads;
            System.debug('Number of leads updated: ' + leads.size());
        } else {
            System.debug('No leads to update.');
        }

        System.debug('DailyLeadProcessor scheduled job completed.');
    }
}