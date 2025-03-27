@isTest
public class SendExternalSystemMockCallOut implements HttpCalloutMock {
    // Implement the respond method to simulate the HTTP response
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        
        // Set the status code of the response
        res.setStatusCode(200);
        
        // Prepare a mock JSON response
        Map<String, Object> responseBody = new Map<String, Object>();
        responseBody.put('message', 'Success');
        responseBody.put('data', 'Mock data response');
        
        // Set the Content-Type and response body in the mock response
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(responseBody));
        
        return res;
    }
}