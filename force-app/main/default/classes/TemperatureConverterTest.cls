@isTest
class TemperatureConverterTest {
   @isTest static void testWarmTemp() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
   }
   @isTest static void testFreezePoint()
   {
       Decimal celsius = TemperatureConverter.FahrenheitToCelsius(32);
       System.assertEquals(0,celsius);
   }
   @isTest static void testBoilingPoint() {
    Decimal celsius = TemperatureConverter.FahrenheitToCelsius(212);
    System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
  }
    
}