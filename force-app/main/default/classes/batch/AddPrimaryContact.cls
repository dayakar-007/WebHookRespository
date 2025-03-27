public class AddPrimaryContact implements Queueable {
    Contact contactToClone;
    String stateAbbreviation;

    public AddPrimaryContact(Contact contactToClone, String stateAbbreviation) {
        System.debug('Constructor called with contact: ' + contactToClone + ' and stateAbbreviation: ' + stateAbbreviation);
        this.contactToClone = contactToClone;
        this.stateAbbreviation = stateAbbreviation;
    }

    public void execute(QueueableContext context) {
        System.debug('Executing AddPrimaryContact for state: ' + stateAbbreviation);
        
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :stateAbbreviation LIMIT 200];
        System.debug('Number of accounts retrieved: ' + accounts.size());

        for (Account account : accounts) {
            Contact newContact = contactToClone.clone(false, true, false, false);
            newContact.AccountId = account.Id;
            contacts.add(newContact);
            System.debug('New contact cloned for account Id: ' + account.Id);
        }

        if (!contacts.isEmpty()) {
            insert contacts;
            System.debug('Number of contacts inserted: ' + contacts.size());
        } else {
            System.debug('No contacts to insert.');
        }
    }
}