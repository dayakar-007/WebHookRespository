@isTest
public class AnimalLocatorTest {
    @isTest
    public static void testGetAnimalNameByIdExist() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        Integer id = 2;
        String expected = 'bear';
        String actual = AnimalLocator.getAnimalNameById(id);
        System.assertNotEquals(null, actual, 'The callout returned a null response.');
        System.assertEquals(expected, actual, 'The animal name does not match the expected value.');
    }
    
       
}