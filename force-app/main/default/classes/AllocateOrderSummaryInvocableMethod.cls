public class AllocateOrderSummaryInvocableMethod {
    @InvocableMethod(label='Allocate Order Summary')
    public static void publishAllocationEvents(List<ID> ids) {
        System.debug('### AllocateOrderSummaryInvocableMethod.publishAllocationEvents() Invoked');
        System.debug('### Input OrderSummary IDs: ' + ids);

        List<allocateOrderSummary__e> llocateEvents = new List<allocateOrderSummary__e>();
        
        // Fetch OrderSummary records
        List<OrderSummary> orderSummary = [
            SELECT Id, Status, PickedupByAllocationBatch_c__c 
            FROM OrderSummary 
            WHERE Id IN :ids
        ];
        
        System.debug('### Retrieved OrderSummary Records: ' + orderSummary.size());

        List<OrderSummary> updateList = new List<OrderSummary>();

        for (OrderSummary os : orderSummary) {
            System.debug('### Processing OrderSummary ID: ' + os.Id);
            System.debug('### Current Status: ' + os.Status);
            System.debug('### PickedupByAllocationBatch_c__c: ' + os.PickedupByAllocationBatch_c__c);

            if (os.Status == 'Closed') {
                System.debug('### Order Allocation cannot execute. OrderSummary is already closed. OrderSummaryId=' + os.Id);
            } else {
                System.debug('### Creating allocateOrderSummary__e event for OrderSummary ID: ' + os.Id);
                allocateOrderSummary__e eDoAlloc = new allocateOrderSummary__e();
                eDoAlloc.orderSummary_Id__c = os.Id;
                llocateEvents.add(eDoAlloc);

                System.debug('### Preparing OrderSummary for update (Approved Status)');
                OrderSummary osUpd = new OrderSummary();
                osUpd.Id = os.Id;
                osUpd.Status = 'Approved';
                osUpd.PickedupByAllocationBatch_c__c = true;
                updateList.add(osUpd);
            }
        }

        // Publish the event if there are events to publish
        if (!llocateEvents.isEmpty()) {
            System.debug('### Publishing ' + llocateEvents.size() + ' allocation events.');
            List<Database.SaveResult> results = EventBus.publish(llocateEvents);

            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('### Successfully published allocation event.');
                } else {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('### ERROR: Event Publishing Failed: ' +
                                     err.getStatusCode() + ' - ' +
                                     err.getMessage());
                    }
                } 
            }
        } else {
            System.debug('### No events to publish.');
        }

        // Update OrderSummary records if any exist in the update list
        if (!updateList.isEmpty()) {
            System.debug('### Updating ' + updateList.size() + ' OrderSummary records.');
            try {
                update updateList;
                System.debug('### OrderSummary records updated successfully.');
            } catch (Exception e) {
                System.debug('### ERROR: Failed to update OrderSummary records: ' + e.getMessage());
            }
        } else {
            System.debug('### No OrderSummary records to update.');
        }

        System.debug('### AllocateOrderSummaryInvocableMethod Execution Completed.');
    }
}