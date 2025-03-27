/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-27-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/webhook/shipment/*')
global with sharing class WebHookHandler {

    @HttpPost
    global static void updateShipmentStatus() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestBody = body.toString();

        System.debug('Webhook Payload: ' + requestBody);

        // Return something so GitHub doesn't timeout
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.responseBody = Blob.valueOf('{"status":"received"}');
        res.addHeader('Content-Type', 'application/json');
    }
}
