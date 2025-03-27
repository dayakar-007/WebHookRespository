public class UpdateContactAddresses implements Database.Batchable<sObject>, Database.Stateful {

    // Instance member to retain state across transactions
    public Integer recordsProcessed = 0;

    // Start method that sets up the batch job query
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, BillingStreet, BillingCity, BillingState, ' +
            'BillingPostalCode, (SELECT ID, MailingStreet, MailingCity, ' +
            'MailingState, MailingPostalCode FROM Contacts) ' +
            'FROM Account WHERE BillingCountry = \'USA\''
        );
    }

    // Execute method that processes each batch of records
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : scope) {
            for (Contact con : acc.contacts) {
                // Map the billing address to mailing address for each contact
                con.MailingStreet = acc.BillingStreet;
                con.MailingCity = acc.BillingCity;
                con.MailingState = acc.BillingState;
                con.MailingPostalCode = acc.BillingPostalCode;
                contacts.add(con);
                recordsProcessed++;
            }
        }
        // Update the contacts with new mailing addresses
        update contacts;
    }

    // Finish method that is called after the batch job completes
    public void finish(Database.BatchableContext bc) {
        System.debug(recordsProcessed + ' records processed. Shazam!');
        
        // Query the AsyncApexJob for this batch job
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()
        ];
        
    }
}