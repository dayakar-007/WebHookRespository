global class CloseOrderBatchJob implements Database.Batchable<sObject>, Database.Stateful {

    global Map<String, Return__mdt> typeProductMap = new Map<String, Return__mdt>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('### start() method invoked - Fetching Return__mdt records');

        for (Return__mdt returnTime : [SELECT Id, Label, Product_Type__c, Time__c FROM Return__mdt]) {
            typeProductMap.put(returnTime.Label, returnTime);
            System.debug('### Added to typeProductMap: Label = ' + returnTime.Label + ', Time = ' + returnTime.Time__c);
        }

        System.debug('### typeProductMap size after population: ' + typeProductMap.size());

        return Database.getQueryLocator([
            SELECT Id, productType__c, CreatedDate, Status 
            FROM OrderSummary 
            LIMIT 20
        ]);
    }

    global void execute(Database.BatchableContext bc, List<OrderSummary> orderSummaryRecords) {
        System.debug('### execute() method invoked - Processing ' + orderSummaryRecords.size() + ' records');

        List<OrderSummary> updateorderSummaryRecords = new List<OrderSummary>();

        for (OrderSummary item : orderSummaryRecords) {
            System.debug('### Processing OrderSummary record - Id: ' + item.Id + ', ProductType: ' + item.productType__c + ', CreatedDate: ' + item.CreatedDate);

            Return__mdt returnConfig = typeProductMap.get(item.productType__c);

            if (returnConfig != null) {
                Integer minutesToAdd = (Integer)returnConfig.Time__c;
                DateTime allocationTime = item.CreatedDate.addMinutes(minutesToAdd);

                System.debug('### Calculated Allocation Time: ' + allocationTime + ' | Current Time: ' + DateTime.now());

                if (allocationTime < DateTime.now() && false) { // `false` is hardcoded - logic won't run
                    item.Status = 'Closed';
                    updateorderSummaryRecords.add(item);
                    System.debug('### OrderSummary record eligible for closure. Added to update list.');
                } else {
                    System.debug('### OrderSummary record not eligible for closure.');
                }
            } else {
                System.debug('### No matching Return__mdt found for ProductType: ' + item.productType__c);
            }
        }

        if (!updateorderSummaryRecords.isEmpty()) {
            update updateorderSummaryRecords;
            System.debug('### Updated ' + updateorderSummaryRecords.size() + ' OrderSummary records.');
        } else {
            System.debug('### No OrderSummary records to update.');
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('### finish() method invoked - Batch completed.');
    }
}