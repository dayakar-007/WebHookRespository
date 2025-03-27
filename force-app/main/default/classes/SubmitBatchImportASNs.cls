/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/Fulfillment/ImportASNs')
global with sharing class SubmitBatchImportASNs{
    @HttpPost
    global static void doPost()
    {
        // List<AdvanceShippingNotice> asn
        System.debug('postMan');
        // List<AdvanceShippingNotice> newASN = asn;  
        
        // System.Debug('Number Of Records ' + newASN);
        
        // BatchImportASNs importASN = new BatchImportASNs(newASN);
        // ID batchprocessid = Database.executeBatch(importASN, 200);

    }
    // Sample Payload:
    //{"asn":[{"FulfillmentOrderNumber":"010789", "FulfillmentOrderItemNumber":"1", "QuantityFulfilled":15, "QuantityCancelled":0}
    //,{"FulfillmentOrderNumber":"217895", "FulfillmentOrderItemNumber":"2", "QuantityFulfilled":20, "QuantityCancelled":1}]}

}