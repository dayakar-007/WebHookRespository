@isTest
public class AnimalsCalloutsTest {
    @isTest
    public static void testGetCallOut() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        System.debug('Mock response created with status code 200 and Content-Type application/json;charset=UTF-8');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        System.debug('Mock response set for HttpCalloutMock');
        
        // Call method to test
        HttpResponse result = AnimalsCallouts.getCallout();
        System.debug('Callout executed and response received: ' + result);
        
        // Verify mock response is not null
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.debug('Verified the response is not null');
        
        // Verify status code
        System.assertEquals(200, result.getStatusCode(), 'The status code is not 200.');
        System.debug('Verified the status code is 200');
        
        // Verify content type
        System.assertEquals('application/json;charset=UTF-8', result.getHeader('Content-Type'), 'The content type value is not expected.');
        System.debug('Verified the content type is application/json;charset=UTF-8');
        
        // Deserialize the response body
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(result.getBody());
        System.debug('Response body deserialized: ' + results);
        
        // Verify the array contains 3 items
        List<Object> animals = (List<Object>) results.get('animals');
        System.debug('Animals list extracted: ' + animals);
        System.assertEquals(3, animals.size(), 'The array should only contain 3 items.');
        System.debug('Verified the array contains 3 items');
    }
}