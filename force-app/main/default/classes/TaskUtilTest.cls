@isTest 
public  class TaskUtilTest {

    @isTest public static void testInvalidInput()
    {
        String result = TaskUtil.getTaskPriority('A');
        System.assertEquals('Normal',result);
        
    }
    @isTest public static void testHigh()
    {
        String result = TaskUtil.getTaskPriority('CA');
        System.assertEquals('High',result);
    }
    @isTest public static void testNormal()
    {
        String result = TaskUtil.getTaskPriority('Dayakar');
        System.assertEquals(null,result);
    }
    
}