@isTest
public class TestRestrictContactByName {
    
    @isTest
    public static void testRestrictContact_Insert_InvalidLastName() {
        // Create a contact with an invalid last name
        Contact testCon = new Contact(FirstName='John', LastName='INVALIDNAME');
        
        Test.startTest();
        try {
            // Attempt to insert the invalid contact
            insert testCon;
            System.assert(false, 'Expected exception not thrown');
        }
        catch (DmlException e) {
            // Assert that the error message contains the expected error
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed for DML'));
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testRestrictContact_Insert_ValidLastName() {
        // Create a contact with a valid last name
        Contact testCon = new Contact(FirstName='John', LastName='Doe');
        
        Test.startTest();
        
        // Insert the valid contact
        insert testCon;
        
        // Query the inserted contact
        Contact insertedContact = [SELECT Id, LastName FROM Contact WHERE Id = :testCon.Id];
        
        // Assert that the last name is 'Doe' after the insert
        System.assertEquals('Doe', insertedContact.LastName, 'Last Name not updated');
        
        Test.stopTest();
    }
}