// Trigger for listening to Cloud_News events.
trigger CloudNewsTrigger on Cloud_News__e (after insert) {
    // List to hold all cases to be created.
    List<Case> cases = new List<Case>();

    // Get queue Id for case owner
    try {
        Group queue = [SELECT Id FROM Group WHERE Name='Regional Dispatch' AND Type='Queue' LIMIT 1];
        System.debug('Queue Id: ' + queue.Id);

        // Iterate through each notification.
        for (Cloud_News__e event : Trigger.New) {
            System.debug('Processing event: ' + event);
            System.debug('Urgent__c: ' + event.Urgent__c);

            if (event.Urgent__c == true) {
                // Create Case to dispatch new team.
                Case cs = new Case();
                cs.Priority = 'High';
                cs.Subject = 'News team dispatch to ' + event.Location__c;
                cs.OwnerId = queue.Id;

                System.debug('Created Case: ' + cs);
                cases.add(cs);
            }
        }

        // Insert all cases corresponding to events received.
        if (!cases.isEmpty()) {
            insert cases;
            System.debug('Inserted Cases: ' + cases);
        } else {
            System.debug('No cases to insert.');
        }
    } catch (Exception e) {
        System.debug('Error in CloudNewsTrigger: ' + e.getMessage());
    }
}