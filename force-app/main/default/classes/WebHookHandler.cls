/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-27-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/webhook/shipment/*')
global with sharing class WebHookHandler {
    public  static void updateShipmentStatus() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestBody = body.toString();
    }
}