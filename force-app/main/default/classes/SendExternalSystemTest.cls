@IsTest
public class SendExternalSystemTest {
    @testSetup
    public static void testSetUp() {
        Id standardPbId = Test.getStandardPricebookId();
        Product2 prod = new Product2(
            Name = 'Test Product',
            ProductCode = '2072100',
            IsActive = true
        );
        insert prod;
        
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPbe;
        
        Account personAcc = new Account(
            FirstName = 'Dayakar',
            LastName = 'Account',
            PersonEmail = 'Dayakar@gmail.com',
            BillingStreet = '1166 W Newport Center Dr',
            BillingCity = 'Deerfield Beach',
            BillingPostalCode = '33442',
            BillingState = 'FL',
            BillingCountry = 'US',
            Phone = '9597542939'
        );
        insert personAcc;
        
        Order ord = new Order(
            Name = 'Test Order',
            Status = 'Draft',
            EffectiveDate = Date.newInstance(2023, 4, 13),
            OrderReferenceNumber = '202107221959-18',
            BillingStreet = '1166 W Newport Center Dr',
            BillingCity = 'Deerfield Beach',
            BillingState = 'FL',
            BillingPostalCode = '33442',
            BillingCountry = 'US',
            BillingPhoneNumber = '9597542939',
            OrderedDate = Datetime.newInstance(2023, 4, 13, 17, 15, 58),
            BillingEmailAddress = 'Dayakar@gmail.com',
            AccountId = personAcc.Id,
            Pricebook2Id = standardPbId
            //TotalAmount = 400,
            //TotalTaxAmount = 40,
            //GrandTotalAmount = 440,
            //OrderNumber = 'O000011'
        );
        insert ord;
        
        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            Quantity = 4,
            //UnitPrice = 100,
            //TotalPrice = 400,
            //TotalTaxAmount = 40,
            UnitPrice = 72.87,
            PricebookEntryId = standardPbe.Id
        );
        insert oi;
    }
    @IsTest
    public static void processExternalSystemDataTest()
    {
        Order testOrder = [SELECT Id FROM Order LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new SendExternalSystemMockCallOut());
        Test.startTest();
        SendExternalSystem.processExternalSystemData(testOrder,'test');
        Test.stopTest();
    }

}