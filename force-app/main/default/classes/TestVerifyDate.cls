@isTest
public  class TestVerifyDate {
   
   @isTest public static void testDateWithin30Days_LessThan30Days()
   {
    Date date1 = Date.newInstance(2019, 1,01);
    Date date2 = date.newInstance(2019,1,30);
    Date result = VerifyDate.CheckDates(date1,date2);
    System.Assert.areEqual(date2,result);

   }
   @isTest public static void testDateOutside30Days_InPast()
   {
    Date date1 = Date.newInstance(2019, 1,29);
    Date date2 = date.newInstance(2019,1,1);
    Date result = VerifyDate.CheckDates(date1,date2);
    Date expected = Date.newInstance(2019,1,31);
    System.Assert.areEqual(expected,result);

   }
   @isTest public static void testDateOutside30Days_MoreThan30Days()
   {
    Date date1 = Date.newInstance(2019, 1,01);
    Date date2 = date.newInstance(2019,2,31);
    Date result = VerifyDate.CheckDates(date1,date2);
    Date expected = Date.newInstance(2019,1,31);
    System.Assert.areEqual(expected,result);

   }
}