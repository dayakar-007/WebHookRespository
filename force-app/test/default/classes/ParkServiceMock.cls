@isTest
global class ParkServiceMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        // Check the endpoint to determine the mock response
        if (req.getEndpoint().contains('Germany')) {
            res.setBody('["Tiergarten", "Englischer Garten"]');
        } else if (req.getEndpoint().contains('India')) {
            res.setBody('["Kaziranga National Park", "Jim Corbett National Park"]');
        } else if (req.getEndpoint().contains('Japan')) {
            res.setBody('["Ueno Park", "Shinjuku Gyoen"]');
        } else if (req.getEndpoint().contains('United States')) {
            res.setBody('["Yellowstone National Park", "Yosemite National Park"]');
        } else {
            res.setBody('[]');
        }
        
        res.setStatusCode(200);
        return res;
    }
}