trigger TriggerOnOpportunity on Opportunity (after update) {
Map<String,Integer> newmap = new Map<String,Integer>();
    newmap.put('Prospecting', 1);
    newmap.put('Qualification', 2);
    newmap.put('Needs Analysis', 3);
    newmap.put('Value Proposition', 4);
    newmap.put('Id. Decision Makers', 5);
    newmap.put('Perception Analysis', 6);
    newmap.put('Proposal/Price Quote', 7);
    newmap.put('Negotiation/Review', 8);
    newmap.put('Closed Won', 9);

    // Loop over all the opportunities in the trigger
    for (Opportunity op : Trigger.new) {
        // Get the previous stage and current stage of the opportunity
        String stageBefore = Trigger.oldMap.get(op.Id).StageName;
        String stageAfter = op.StageName;

        // If the previous stage was 'Closed Lost', do nothing
        if(stageAfter == stageBefore)
        {
            continue;
        }
        if (stageBefore == 'Closed Lost') {
            op.addError('This opportunity is marked as Closed Lost and cannot be updated.');
            continue;
        }

        // If the stage transition is more than one step, show an error
        if (newmap.containsKey(stageBefore) && newmap.containsKey(stageAfter)) {
            Integer stageBeforeValue = newmap.get(stageBefore);
            Integer stageAfterValue = newmap.get(stageAfter);

            // If the move is more than one step forward, prevent the update
            if (stageAfterValue != (stageBeforeValue + 1)) {
                op.addError('You can only move one step forward in the opportunity stage.');
            }
        }
    }
}