trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
    List<Task> tasksToInsert = new List<Task>();
    for (Opportunity op : Trigger.new) {

        if(op.StageName=='Closed Won')
        {
            Task task = new Task(
                Subject = 'Follow Up Test Task',
                WhatId = op.Id
            );
            tasksToInsert.add(task);
            
        }
    }
    if(!tasksToInsert.isEmpty())
    {
        insert tasksToInsert;
    }

}