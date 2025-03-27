/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-26-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class FulfillmentHelper {
    @AuraEnabled(cacheable = true)
    public static List<FulfillmentOrderLineItem> getFulfillmentLines(Id fulfillmentId)
    {
        return[SELECT Id,Description,Quantity, Quantity_Fulfilled__c FROM FulfillmentOrderLineItem WHERE  FulfillmentOrderId=:fulfillmentId];
    }
    @AuraEnabled
    public static void updateFulfillmentLineItems(List<Map<String, Object>> linesToUpdate,String fulfillmentId)
    {
        Integer totalQuantity = 0;
        List<Id> lineIds = new List<Id>();
        Map<Id,String> lineIdToDescription = new Map<Id,String>();
        for (Map<String, Object> line : linesToUpdate) {
            Id lineId = (Id)line.get('Id');
            String description = (String)line.get('selectedQuantity');
        
            // Add to collections
            lineIds.add(lineId);
            lineIdToDescription.put(lineId, description);
        }
        List<FulfillmentOrderLineItem>  updateFulfillmentLineItemsTRecord= [SELECT Id, Quantity_Fulfilled__c FROM FulfillmentOrderLineItem WHERE Id IN :lineIds];
        for(FulfillmentOrderLineItem line : updateFulfillmentLineItemsTRecord)
        {
            if(line.Quantity_Fulfilled__c == null)
            {
                line.Quantity_Fulfilled__c = 0;
            }
            system.debug('Quantity_Fulfilled__c: ' + line.Quantity_Fulfilled__c);
            line.Quantity_Fulfilled__c += Integer.valueOf(lineIdToDescription.get(line.Id));
            totalQuantity += Integer.valueOf(lineIdToDescription.get(line.Id));
            system.debug('Quantity_Fulfilled__c: ' + line.Quantity_Fulfilled__c);
        }
        if( updateFulfillmentLineItemsTRecord.size() > 0){ 
             update updateFulfillmentLineItemsTRecord;
         }
        System.debug('linesToUpdate: ' + updateFulfillmentLineItemsTRecord);

    }
    public void createShipment( Map<Id,String> fulfillmentIdToQuantity,String fulfillmentId,Integer totalQuantity)
    {
        Shipment newShipment = new Shipment();
        List<ShipmentItem> newShipmentItem = new List<ShipmentItem>();
        FulfillmentOrder fulfillmentRecord=[SELECT Id,OrderSummaryId,FulfilledToAddress,DeliveryMethodId,FulfilledFromLocationId FROM FulfillmentOrder WHERE Id = :fulfillmentId LIMIT 1];
        newShipment.OrderSummaryId = fulfillmentRecord.OrderSummaryId;
        newShipment.FulfillmentOrderId = fulfillmentRecord.Id;
        newShipment.DeliveryMethodId = fulfillmentRecord.DeliveryMethodId;
        newShipment.Status = 'Created';
        insert newShipment;
        Map<Id,FulfillmentOrderLineItem> fulfillmentLineItems = new Map<Id,FulfillmentOrderLineItem>([SELECT Id,order OrderItemSummaryId,Product2Id FROM FulfillmentOrderLineItem WHERE Id IN :fulfillmentIdToQuantity.keySet()]);
    }

}