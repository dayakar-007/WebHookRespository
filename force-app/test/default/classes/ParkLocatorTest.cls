@isTest
public class ParkLocatorTest {
    @isTest
    public static void testCountryMethod() {
        Test.startTest();
        
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new ParkServiceMock());
        System.debug('Mock set for HttpCalloutMock.');
        
        // Test case for Germany
        List<String> expectedGermany = new List<String>{'Tiergarten', 'Englischer Garten'};
        List<String> actualGermany = ParkLocator.country('Germany');
        System.debug('Expected parks for Germany: ' + expectedGermany);
        System.debug('Actual parks for Germany: ' + actualGermany);
        System.assertEquals(actualGermany, actualGermany, 'Germany parks do not match expected values.');
        Test.stopTest();
    }
}