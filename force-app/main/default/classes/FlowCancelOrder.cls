public class FlowCancelOrder {
    static List<ExternalSystemWrapper> externalSystemWrapperList = new List<ExternalSystemWrapper>();
    static Set<Id> orderItemSummaryIds = new Set<Id>();
    static Map<Id, OrderItemSummary> orderItemSummaryMap = new Map<Id, OrderItemSummary>();

    public class CancelOrderWrapper {
        @InvocableVariable(label = 'Cancel Order' description = 'Variable' required = true)
        public List<Cancel_Order__c> cancel_order;
        
        
        @InvocableVariable(label = 'grandTotalAmount' description = 'GrandTotal' required = true)
        public String grandTotalAmount;
        @InvocableVariable(label = 'totalAdjustedDeliveryAmount' description = 'totalAdjustedDeliveryAmount' required = true)
        public String totalAdjustedDeliveryAmount;
        @InvocableVariable(label = 'totalAdjustedProductAmount' description = 'totalAdjustedProductAmount' required = true)
        public String totalAdjustedProductAmount;
        @InvocableVariable(label = 'totalAdjustmentDistributedAmount' description = 'totalAdjustmentDistributedAmount' required = true)
        public String totalAdjustmentDistributedAmount;
        @InvocableVariable(label = 'totalTaxAmount' description = 'totalTaxAmount' required = true)
        public String totalTaxAmount;
        
        
    }

    @InvocableMethod(label = 'Cancel Order items' description = 'Cancel order item' category = 'Cancel_Order__c')
    public static void processRequest(List<CancelOrderWrapper> requestList) {
        System.debug('From the flow apex method invoked');
        Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(requestList[0]));
		for (String key : requestData.keySet()) {
    		System.debug(key + ': ' + requestData.get(key));
		}
        EmailData emailData = new EmailData(requestList[0].cancel_order,requestList[0].grandTotalAmount,requestList[0].totalTaxAmount,requestList[0].totalAdjustmentDistributedAmount,requestList[0].totalAdjustedProductAmount,requestList[0].totalAdjustedDeliveryAmount);
        CancelOrderEmailSender.sendEmail(emailData,'naraladayakar072@gmail.com');
        /*if (requestList != null && !requestList.isEmpty() && requestList[0].cancel_order != null) {
            for (Cancel_Order__c cancel : requestList[0].cancel_order) {
                if (cancel.OrderItemSummaryId__c != null) {
                    orderItemSummaryIds.add(cancel.OrderItemSummaryId__c);
                }
            }

            if (!orderItemSummaryIds.isEmpty()) {
                orderItemSummaryMap = new Map<Id, OrderItemSummary>(
                    [SELECT Id, OrderSummary.OrderNumber, OriginalOrderItem.OrderItemNumber, Name
                     FROM OrderItemSummary
                     WHERE Id IN :orderItemSummaryIds]
                );

                System.debug('Fetched OrderItemSummary Records: ' + orderItemSummaryMap);
             
            } else {
                System.debug('No valid OrderItemSummary Ids found.');
            }
            for (Cancel_Order__c cancel : requestList[0].cancel_order) {
                if (cancel.OrderItemSummaryId__c != null) {
                    ExternalSystemWrapper externalSystemWrapper = new ExternalSystemWrapper();
                    externalSystemWrapper.Name = orderItemSummaryMap.get(cancel.OrderItemSummaryId__c).Name;
                    externalSystemWrapper.OrderProductSummary = orderItemSummaryMap.get(cancel.OrderItemSummaryId__c).OriginalOrderItem.OrderItemNumber;
                    externalSystemWrapper.OrderSummary = orderItemSummaryMap.get(cancel.OrderItemSummaryId__c).OrderSummary.OrderNumber;
                    externalSystemWrapper.quantity = (Integer)cancel.Cancel_Quantity__c;
                    externalSystemWrapper.reason = cancel.Reason__c;
                    externalSystemWrapperList.add(O);
                }
            }
            if(!externalSystemWrapperList.isEmpty())
            {
                SendExternalSystem.processExternalSystemData(externalSystemWrapperList);
            }
        } else {
            System.debug('No orders to cancel.');
        }*/
    }
}