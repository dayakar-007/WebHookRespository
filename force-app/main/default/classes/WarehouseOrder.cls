/**
 * @description       : Represents an order with a list of order line items.
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class WarehouseOrder {
    global String orderId { get; set; }
    global List<WarehouseOrderLineItem> orderLineItems { get; set; }

    // // Global static method to deserialize JSON into a WarehouseOrder instance
    global static WarehouseOrder parse(String jsonString) {
        return (WarehouseOrder) JSON.deserialize(jsonString, WarehouseOrder.class);
    }
}