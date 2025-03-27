/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderEventTrigger on Order_Event__e (after insert) {
    List<Task> tasks = new List<Task>();
    for(Order_Event__e events:Trigger.new)
    {
        if(events.Has_Shipped__c == true){
        Task task =new Task();
        task.Priority = 'Medium';
        task.Subject = 'Follow up on shipped order 105';
        task.OwnerId = events.CreatedById;
            tasks.add(task);
        }
    }
    if(!tasks.isEmpty())
    {
        insert tasks;
    }

}