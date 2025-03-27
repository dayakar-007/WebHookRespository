/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class BatchImportWareHouse implements Database.Batchable<sObject>, Database.Stateful {
    private WarehouseOrder warehouseOrder = null;
    global Map<String, Map<String, WarehouseOrderLineItem>> warehouseOrderRecords = new Map<String, Map<String, WarehouseOrderLineItem>>();
    
    public BatchImportWareHouse(WarehouseOrder warehouseOrder) {
        this.warehouseOrder = warehouseOrder;
        System.debug('DEBUG: BatchImportWareHouse constructor called with WarehouseOrder: ' + warehouseOrder);
    }
   
    global List<FulfillmentOrder> start(Database.BatchableContext bc) {
        System.debug('DEBUG: start() method invoked.');
        prepareDat();
        System.debug('DEBUG: Prepared warehouseOrderRecords: ' + warehouseOrderRecords);
        
        List<FulfillmentOrder> fos = [SELECT Id, FulfillmentOrderNumber, FulfilledToName, OrderSummary.OriginalOrder.OrderNumber, Status, OrderSummaryId,
                                        (SELECT Id, FulfillmentOrderLineItemNumber, Quantity,  Quantity_Fulfilled__c, Product2.ProductCode 
                                         FROM FulfillmentOrderLineItems) 
                                      FROM FulfillmentOrder 
                                      WHERE OrderSummary.OriginalOrder.OrderNumber IN :warehouseOrderRecords.keySet()];
        System.debug('DEBUG: Query returned ' + fos.size() + ' FulfillmentOrder records.');
        Integer totalLineItems = 0;
		for (FulfillmentOrder fo : fos) {
    		if (fo.FulfillmentOrderLineItems != null) {
        		totalLineItems += fo.FulfillmentOrderLineItems.size();
    		}
		}
		System.debug('DEBUG: Total number of Fulfillment Order Line Items: ' + totalLineItems);

        return fos;
    }
    
    global void execute(Database.BatchableContext bc, List<FulfillmentOrder> fulfillmentOrders) {
       System.debug('DEBUG: execute() method invoked with ' + fulfillmentOrders.size() + ' FulfillmentOrder records.');
        
        WarehouseOrderLineItem warehouseOrderLineItem = null;
        Shipment shipment = null;
        List<FulfillmentOrder> foToUpdateList = new List<FulfillmentOrder>();
        List<FulfillmentOrderLineItem> foItemToUpdateList = new List<FulfillmentOrderLineItem>();
        List<Shipment> shipmentList = new List<Shipment>();
        List<String> orderSummaryList = new List<String>();
        
        for (FulfillmentOrder fulfillmentOrder : fulfillmentOrders) {
            System.debug('DEBUG: Processing FulfillmentOrder with OrderNumber: ' + fulfillmentOrder.OrderSummary.OriginalOrder.OrderNumber);
            boolean foCompleted = true;
            Map<String, WarehouseOrderLineItem> foItems = warehouseOrderRecords.get(fulfillmentOrder.OrderSummary.OriginalOrder.OrderNumber);
            if (foItems == null) {
                System.debug('DEBUG: No matching order line items found for OrderNumber: ' + fulfillmentOrder.OrderSummary.OriginalOrder.OrderNumber);
                continue;
            }
            for (FulfillmentOrderLineItem fulfillmentOrderLineItem : fulfillmentOrder.FulfillmentOrderLineItems) {
                System.debug('DEBUG: Processing FulfillmentOrderLineItem with ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode);
                if (foItems.containsKey(fulfillmentOrderLineItem.Product2.ProductCode)) {
                    warehouseOrderLineItem = foItems.get(fulfillmentOrderLineItem.Product2.ProductCode);
                    if (warehouseOrderLineItem.quantity == 0) {
                        System.debug('ERROR: Quantity is 0 for ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode);
                        continue;
                    }
                    if (fulfillmentOrderLineItem.Quantity_Fulfilled__c == null) {
                        fulfillmentOrderLineItem.Quantity_Fulfilled__c = 0;
                        System.debug('DEBUG: Initialized Quantity_Fulfilled__c to 0 for ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode);
                    }
                    if (warehouseOrderLineItem.quantity > fulfillmentOrderLineItem.Quantity) {
                        System.debug('ERROR: Quantity Mismatch for ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode +
                                     '. Warehouse quantity: ' + warehouseOrderLineItem.quantity +
                                     ', Fulfillment quantity: ' + fulfillmentOrderLineItem.Quantity);
                        return;
                    }
                    if (warehouseOrderLineItem.quantity < (fulfillmentOrderLineItem.Quantity - fulfillmentOrderLineItem.Quantity_Fulfilled__c)) {
                        System.debug('DEBUG: Partial fulfillment for ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode);
                        foCompleted = false;
                    }
                    fulfillmentOrderLineItem.Quantity_Fulfilled__c += warehouseOrderLineItem.quantity;
                    System.debug('DEBUG: Updated Quantity_Fulfilled__c for ProductCode: ' + fulfillmentOrderLineItem.Product2.ProductCode +
                                 ' to ' + fulfillmentOrderLineItem.Quantity_Fulfilled__c);
                    foItemToUpdateList.add(fulfillmentOrderLineItem);
                } else {
                    System.debug('ERROR: Product Code not found: ' + fulfillmentOrderLineItem.Product2.ProductCode);
                }
            }
            if (foCompleted) {
                fulfillmentOrder.Status = 'Fulfilled';
                foToUpdateList.add(fulfillmentOrder);
                orderSummaryList.add(fulfillmentOrder.OrderSummaryId);
                System.debug('DEBUG: FulfillmentOrder marked as Fulfilled for OrderSummaryId: ' + fulfillmentOrder.OrderSummaryId);
            } else {
                System.debug('DEBUG: FulfillmentOrder NOT fully completed for OrderSummaryId: ' + fulfillmentOrder.OrderSummaryId);
            }
            shipment = new Shipment();
            shipment.OrderSummaryId = fulfillmentOrder.OrderSummaryId;
            shipment.FulfillmentOrderId = fulfillmentOrder.Id;
            shipment.ShipToName  = fulfillmentOrder.FulfilledToName;
            shipmentList.add(shipment);
            
            System.debug('DEBUG: Shipment created: ' + shipment);
            System.debug('DEBUG: Current lists sizes - foItemToUpdateList: ' + foItemToUpdateList.size() +
                         ', foToUpdateList: ' + foToUpdateList.size() +
                         ', orderSummaryList: ' + orderSummaryList.size());
            
            if (shipmentList.size() > 0) {
    			insert shipmentList;
    			System.debug('DEBUG: Inserted ' + shipmentList.size() + ' Shipment records.');
    			// Iterate over the list and print each Shipment Id
    			for (Shipment s : shipmentList) {
        			System.debug('DEBUG: Shipment ID: ' + s.Id);
    			}
    
    			shipmentList.clear();
			}

            if (foItemToUpdateList.size() > 0) {
                update foItemToUpdateList;
                System.debug('DEBUG: Updated ' + foItemToUpdateList.size() + ' FulfillmentOrderLineItem records.');
                foItemToUpdateList.clear();
            }
            if (foToUpdateList.size() > 0) {
                update foToUpdateList;
                System.debug('DEBUG: Updated ' + foToUpdateList.size() + ' FulfillmentOrder records.');
                foToUpdateList.clear();
            }
            if (orderSummaryList.size() > 0) {
                List<OrderSummary> orderSummaries = [SELECT Id, Status FROM OrderSummary WHERE Id IN :orderSummaryList];
                for (OrderSummary orderSummary : orderSummaries) {
                    orderSummary.Status = 'Fulfilled';
                }
                update orderSummaries;
                System.debug('DEBUG: Updated OrderSummary records for OrderSummary IDs: ' + orderSummaryList);
                orderSummaryList.clear();
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('DEBUG: finish() method invoked. Batch Process Completed.');
    }
    
    private void prepareDat() {
    System.debug('DEBUG: Preparing warehouse order records from WarehouseOrder.');
    
    // Ensure the outer map is initialized for this orderId
    if (!warehouseOrderRecords.containsKey(warehouseOrder.orderId)) {
        warehouseOrderRecords.put(warehouseOrder.orderId, new Map<String, WarehouseOrderLineItem>());
        System.debug('DEBUG: Created new map entry for OrderId: ' + warehouseOrder.orderId);
    }
    
    // Iterate over each order line item and add to the inner map keyed by orderLineItemCode
    for (WarehouseOrderLineItem orderLineItem : warehouseOrder.orderLineItems) {
        warehouseOrderRecords.get(warehouseOrder.orderId).put(orderLineItem.orderLineItemCode, orderLineItem);
        System.debug('DEBUG: Added WarehouseOrderLineItem for Product Code: ' + orderLineItem.orderLineItemCode +
                     ' under OrderId: ' + warehouseOrder.orderId);
    }
    
    System.debug('Map: ' + warehouseOrderRecords);
}

}