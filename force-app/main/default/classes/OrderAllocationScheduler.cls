global class OrderAllocationScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        System.debug('### OrderAllocationScheduler: Starting the OrderAllocationBatch Job...');
        
        // Execute the Batch
        OrderAllocationBatch batch = new OrderAllocationBatch();
        Database.executeBatch(batch, 200);
        
        System.debug('### OrderAllocationScheduler: OrderAllocationBatch Job Scheduled Successfully.');
    }
}