trigger OrderAllocationTrigger on allocateOrderSummary__e (after insert) {
    System.debug('OrderAllocationTrigger');
    
}