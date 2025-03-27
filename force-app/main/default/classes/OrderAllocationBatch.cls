public class OrderAllocationBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('### OrderAllocationBatch START METHOD: Fetching records...');
        
        return Database.getQueryLocator([
            SELECT Id, Status, HoursOld_c__c 
            FROM OrderSummary 
            WHERE Status = 'Created'
            AND HoursOld_c__c >= 36
            AND PickedupByAllocationBatch_c__c = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<OrderSummary> records) {
        System.debug('### OrderAllocationBatch EXECUTE METHOD: Processing ' + records.size() + ' records');

        if (records.isEmpty()) {
            System.debug('### No records found that meet criteria.');
            return;
        }

        List<allocateOrderSummary__e> events = new List<allocateOrderSummary__e>();

        for (OrderSummary order : records) {
            System.debug('### Processing OrderSummary Id: ' + order.Id);

            allocateOrderSummary__e event = new allocateOrderSummary__e(
                orderSummary_Id__c = order.Id
            );

            events.add(event);
        }

        if (!events.isEmpty()) {
            System.debug('### Publishing ' + events.size() + ' platform events.');
            EventBus.publish(events); // Publish events for processing
        } else {
            System.debug('### No events to publish.');
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('### OrderAllocationBatch FINISH METHOD: Batch Execution Completed.');
    }
}