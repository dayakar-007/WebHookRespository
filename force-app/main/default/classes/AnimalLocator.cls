public class AnimalLocator {
    public static String getAnimalNameById(Integer id)
    {
        String endpoint = ' https://th-apex-http-callout.herokuapp.com/animals/'+id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String animalName = '';
        if(response.getStatusCode() == 200)
        {
            Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> animalMap = (Map<String, Object>) responseMap.get('animal'); 
            animalName= (String) animalMap.get('name');
            
        }
        return animalName;
       
        
    }
    
    
}