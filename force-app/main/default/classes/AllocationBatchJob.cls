global class AllocationBatchJob implements Database.Batchable<sObject> {
    private boolean skipRemorsePeriod = false; 
    private String query = 'SELECT Id, OrderedDate, Status, (SELECT Id FROM OrderSummaryRoutingSchedules WHERE ScheduleStatus = \'SCHEDULED\') FROM OrderSummary WHERE Status =\'Created\'AND  PickedupByAllocationBatch_c__c = false AND HoursOld_c__c >= 36 ORDER BY OrderedDate';

    public AllocationBatchJob() {
        System.debug('### AllocationBatchJob Constructor: Instance Created');
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('### AllocationBatchJob.start() Invoked');

        // Fetching SQL limit settings from Custom Metadata
        List<AllocationJobSetting__mdt> sqlLimitSettings = [
            SELECT sqlLimitRecords__c FROM AllocationJobSetting__mdt WHERE Label = 'Default Remorse Period' LIMIT 1
        ];

        if (sqlLimitSettings != null && !sqlLimitSettings.isEmpty() && sqlLimitSettings[0].sqlLimitRecords__c != null && sqlLimitSettings[0].sqlLimitRecords__c > 0) {
            this.query = this.query + ' LIMIT ' + String.valueOf(sqlLimitSettings[0].sqlLimitRecords__c);
            System.debug('### Query Updated with LIMIT: ' + this.query);
        } else {
            System.debug('### No SQL Limit Records Found. Running Default Query.');
        }

        System.debug('### Final SOQL Query: ' + this.query);
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext bc, List<OrderSummary> osList) {
        System.debug('### AllocationBatchJob.execute() Invoked');
        System.debug('### Batch Size: ' + osList.size());

        List<Id> ids = new List<Id>();

        // Fetching customer remorse period from metadata
        List<AllocationJobSetting__mdt> lAllocSettings = [
            SELECT Id, Label, customerRemorsePeriodMinutes__c FROM AllocationJobSetting__mdt WHERE Label = 'Default Remorse Period'
        ];

        if (lAllocSettings.isEmpty()) {
            System.debug('### ERROR: No AllocationJobSetting__mdt record found!');
            return;
        }

        Integer t_CustomerRemorsePeriodMinutes = lAllocSettings[0].customerRemorsePeriodMinutes__c.intValue();
        System.debug('### Retrieved Remorse Period (Minutes): ' + t_CustomerRemorsePeriodMinutes);

        for (OrderSummary os : osList) {
            System.debug('### Processing OrderSummary: ' + os.Id);

            boolean scheduleExist = false;
            DateTime allocationTime = os.OrderedDate.addMinutes(t_CustomerRemorsePeriodMinutes);
            System.debug('### Order Ordered Date: ' + os.OrderedDate);
            System.debug('### Calculated Allocation Time: ' + allocationTime);

            if (os.OrderSummaryRoutingSchedules != null && !os.OrderSummaryRoutingSchedules.isEmpty()) {
                scheduleExist = true;
                System.debug('### Schedule Exists for OrderSummary: ' + os.Id);
            }

            if (allocationTime < DateTime.now() && !scheduleExist) {
                System.debug('### Adding OrderSummary to Allocation List: ' + os.Id);
                ids.add(os.Id);
            } else {
                System.debug('### Skipping OrderSummary: ' + os.Id);
            }
        }

        if (!ids.isEmpty()) {
            System.debug('### Invoking AllocateOrderSummaryInvocableMethod with ' + ids.size() + ' Orders.');
            AllocateOrderSummaryInvocableMethod.publishAllocationEvents(ids);
        } else {
            System.debug('### No Orders to Process in this Batch.');
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('### AllocationBatchJob.finish() Invoked');
        System.debug('### Batch Job Execution Completed');
    }
}