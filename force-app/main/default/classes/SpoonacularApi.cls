public class SpoonacularApi {
    private static String API_ENDPOINT='https://api.spoonacular.com';
    private static spoonacular_API__c spoonacular_API = spoonacular_API__c.getInstance(UserInfo.getUserId());
    private static final String SECRET_KEY=spoonacular_API.Secret_Key__c;
    public static String getRandomRecipe()
    {

        System.debug('Sercet key'+SECRET_KEY);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_ENDPOINT+'/recipes/random?apiKey='+SECRET_KEY);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('Response code is:'+response.getStatusCode());
        if(response.getStatusCode()==200)
        {
            return response.getBody();
        }
        return '';
    }

    public static String getRecipe(String recipeId)
    {

        System.debug('Sercet key'+SECRET_KEY);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        // https://api.spoonacular.com/recipes/{id}/information
        request.setEndpoint(API_ENDPOINT+'/recipes/'+recipeId+'/information?apiKey='+SECRET_KEY);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('Response code is:'+response.getStatusCode());
        if(response.getStatusCode()==200)
        {
           return response.getBody();
        }
        return '';
    }

    public static String getRecipeByIngredients(String Ingredients)
    {

        System.debug('Sercet key'+SECRET_KEY);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //https://api.spoonacular.com/recipes/findByIngredients
        request.setEndpoint(API_ENDPOINT+'/recipes/findByIngredients?apiKey='+SECRET_KEY+'&ingredients='+Ingredients);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('Response code is:'+response.getStatusCode());
        if(response.getStatusCode()==200)
        {
          return response.getBody();
        }
        return '';
    }
   
}