@RestResource(urlMapping='/MyRestService/*')
global with sharing  class RestController {
    @HttpPost
    global static void processMessage() {
        String jsonBody = RestContext.request.requestBody.toString();
        Contact contact = (Contact) JSON.deserialize(jsonBody, Contact.class);
        System.debug('Received message: ' + contact);
        INSERT contact;
        System.debug('contact Id'+contact.Id);
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(Contact));
    }
}