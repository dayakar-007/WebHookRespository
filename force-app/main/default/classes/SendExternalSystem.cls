public class SendExternalSystem {
    public static HttpResponse res;
    public static Order changeOrder;
    @future(callout=true)
    public static void sendData(String jsonPayload) {
        if (String.isNotBlank(jsonPayload)) {
            try {
                System.debug('Serialized JSON Payload: ' + jsonPayload);

                // Prepare the HTTP request
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:External_System_Cancel_Items/services/apexrest/CancelItems'); // Replace with your endpoint
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setBody(jsonPayload);

                // Send the HTTP request
                Http http = new Http();
                res = http.send(req);

                // Log the response
                System.debug('Response Status: ' + res.getStatus());
                System.debug('Response Body: ' + res.getBody());
                sucessFullyDataRecived(changeOrder);
            } catch (Exception e) {
                System.debug('Error during HTTP callout: ' + e.getMessage());
            }
        } else {
            System.debug('No data to send to the external system.');
        }
    }

    // Helper method to serialize and call the future method
    public static void processExternalSystemData(Order changeOrder,String level) {
        if (changeOrder != null) {
            SendExternalSystem.changeOrder = changeOrder;
            String jsonPayload = JSON.serialize(new OrderWrapper(changeOrder,level));
            sendData(jsonPayload);
        } else {
            System.debug('No data available to process.');
        }
    }
    public static void sucessFullyDataRecived(Order order)
    {
        order.Data_Recived_SucessFully__c = true;
        update order;
    }
}