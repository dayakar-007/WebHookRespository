trigger oppertunityAutomation on Opportunity (before insert,before update,after insert,after update) {
    
    //trigger oppertunityAutomation on Opportunity (before insert,before update,after insert,after update)
    // Handle BEFORE_INSERT and BEFORE_UPDATE
    if (Trigger.isBefore) {
        List<Opportunity>opps=Trigger.new;
        for (Opportunity op : opps) {
            // Set the NextStep only if it is not already set
            if(op.StageName=='Closed Won'){
                    if (op.NextStep == null) {
                        op.NextStep = 'OnBoard a Contract';
                    }
                }   
        }
    }
    
    // Handle AFTER_INSERT and AFTER_UPDATE
    // changesmade
    if (Trigger.isAfter) {
        List<Task> tasksToInsert = new List<Task>();
        
        for (Opportunity op : Trigger.new) {
            // Create multiple tasks for each opportunity
            if(op.StageName=='Closed Won'){
                Task engaged = new Task();
                engaged.WhatId = op.Id;
                engaged.Subject = 'Engaged with customer';
                tasksToInsert.add(engaged);
                
                Task scheduleCall = new Task();
                scheduleCall.WhatId = op.Id;
                scheduleCall.Subject = 'Schedule a call';
                tasksToInsert.add(scheduleCall);
                
                Task email = new Task();
                email.WhatId = op.Id;
                email.Subject = 'Thank you email';
                tasksToInsert.add(email);
            } 
        }
        
        // Insert all tasks in a single DML operation
        insert tasksToInsert;
    }
}