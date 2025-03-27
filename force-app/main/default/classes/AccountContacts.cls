public class AccountContacts {

    // Method to retrieve contacts for a given Account ID
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String recordId) {
        System.debug('DEBUG: Received AccountID: ' + recordId);
        List<Contact> contacts = [SELECT Id, Name, Email, Account.Name FROM Contact WHERE AccountId = :recordId];
        return contacts;
    }

    // Method to delete a contact
    @AuraEnabled
    public static void deleteContact(String conId) {
        try {
            System.debug('DEBUG: Received ContactID for delete: ' + conId);

            // Query the contact to delete (LIMIT 1 ensures we only get the contact for deletion)
            List<Contact> contacts = [SELECT Id FROM Contact WHERE Id = :conId LIMIT 1];

            if (contacts.isEmpty()) {
                System.debug('ERROR: Contact not found.');
                return;
            }

            // Ensure only one DML operation is performed
            System.debug('DEBUG: Contact found. Proceeding with delete.');

            // Perform delete operation
            delete contacts;

            System.debug('DEBUG: Contact deleted successfully.');
        } catch (DmlException e) {
            // Handle DML-specific errors
            System.debug('ERROR: DML Exception occurred while deleting contact: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while deleting the contact: ' + e.getMessage());
        } catch (Exception e) {
            // Handle general exceptions
            System.debug('ERROR: Exception occurred while deleting contact: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while deleting the contact: ' + e.getMessage());
        }
    }
}