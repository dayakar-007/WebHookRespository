/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/Fulfillment/WareHouse')
global with sharing class WareHouseRestController {
    @HttpPost
    global static void doPost() {
        System.debug('--- WareHouseRestController.doPost() START ---');
        
        // Log the incoming request body
        String requestBody = RestContext.request.requestBody.toString();
        System.debug('Request Body: ' + requestBody);
        
        // Deserialize JSON into a WarehouseOrder object
        WarehouseOrder order;
        try {
            order = (WarehouseOrder) JSON.deserialize(requestBody, WarehouseOrder.class);
            System.debug('Successfully deserialized WarehouseOrder object.');
        } catch(Exception e) {
            System.debug('Error during deserialization: ' + e.getMessage());
            // Optionally rethrow or handle error accordingly
            return;
        }
        
        // Log details from the deserialized object
        if(order != null && order.orderLineItems != null) {
            System.debug('Number Of Order Line Items: ' + order.orderLineItems.size());
        } else {
            System.debug('WarehouseOrder or its orderLineItems list is null.');
        }
        
        // Future implementation: batch process for warehouse orders
           BatchImportWareHouse importWarehouse = new BatchImportWareHouse(order);
           ID batchprocessid = Database.executeBatch(importWarehouse, 200);
           System.debug('Batch process initiated with ID: ' + batchprocessid);
        
        System.debug('--- WareHouseRestController.doPost() END ---');
    }
}