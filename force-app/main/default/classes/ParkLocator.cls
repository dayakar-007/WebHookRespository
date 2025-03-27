public class ParkLocator {
    public static List<String> country(String countryName) {
        System.debug('Calling ParkService to get parks for country: ' + countryName);
        
        List<String> parks = new List<String>();
        
        try {
            ParkService.ParksImplPort park = new ParkService.ParksImplPort();
            System.debug('ParkService.ParksImplPort instantiated successfully');
            
            parks = park.byCountry(countryName);
            System.debug('Received parks: ' + parks);
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
        
        return parks;
    }
}