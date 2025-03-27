trigger SendEmailOnTheUpdatedContacts on Contact (after update) {

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    // Iterate through the new Contact records in the trigger
    List<Contact> conList = Trigger.new;
    System.debug('Trigger new contacts: ' + conList); // Debug log to see the list of inserted contacts

    for (Contact con : conList) {
        // Check if the Contact has an email address
        if (con.Email != null) {
            System.debug('Contact with Email found' + con.Email); // Log contact email address

            // Create an email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set the email parameters
            email.setToAddresses(new String[] {con.Email});
            email.setSubject('Your Contact Information has been Updated');
            email.setPlainTextBody('Dear ' + con.FirstName + ',\n\nYour contact information has been updated. Please check your details.');

            // Add the email to the list
            emails.add(email);
        } else {
            System.debug('Contact without Email: ' + con.Id); // Log contact without email
        }
    }

    // Send all the emails in a single call to avoid hitting governor limits
    if (!emails.isEmpty()) {
        System.debug('Sending emails to: ' + emails.size() + ' contacts'); // Log number of emails to be sent
        Messaging.sendEmail(emails);
    } else {
        System.debug('No emails to send'); // Log if no emails were found
    }

}