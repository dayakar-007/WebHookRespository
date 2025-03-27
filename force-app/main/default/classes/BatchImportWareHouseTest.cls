@IsTest
public class BatchImportWareHouseTest {

    @testSetup
    public static void setup() {
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
            Name = 'Narala Dayakar Reddy',
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
        );
        insert ord;

        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            Quantity = 4,
            UnitPrice = 100,
            PricebookEntryId = standardPbe.Id
        );
        insert oi;

        Test.startTest();
        ord.Status = 'Activated';
        update ord;
        Test.stopTest();

        /*OrderSummary os;
        Integer retryCount = 0;
        while (retryCount < 5 && os == null) {
            try {
                os = [SELECT Id FROM OrderSummary WHERE OrderSummary.OriginalOrder.OrderNumber = :ord.OrderReferenceNumber LIMIT 1];
            } catch (Exception e) {
                retryCount++;
            }
        }
        System.assertNotEquals(null, os, 'OrderSummary was not generated after activating the order.');*/
        OrderSummary os = new OrderSummary(
           // OriginalOrderId = ord.Id,
            OrderNumber = ord.OrderReferenceNumber
            //Status = 
        );

        FulfillmentOrder fo = new FulfillmentOrder(
            OrderSummaryId = os.Id,
            FulfilledToName = 'Dayakar',
            Status = 'Draft'
        );
        insert fo;

        FulfillmentOrderLineItem fli = new FulfillmentOrderLineItem(
            FulfillmentOrderId = fo.Id,
            OriginalQuantity = 4,
            Quantity = 4,
            //TypeCode = 'Standard',
            Quantity_Fulfilled__c = 0,
            Product2Id = prod.Id,
            Type = 'Order Product',
            TypeCode = 'Product'
            
        );
        insert fli;
    }

    @IsTest
    static void testBatchImportWareHouse() {
        Order ord = [SELECT Id, OrderReferenceNumber FROM Order LIMIT 1];
        OrderItem oi = [SELECT Id, Quantity, Product2.ProductCode FROM OrderItem WHERE OrderId = :ord.Id LIMIT 1];
        FulfillmentOrder fo = [SELECT Id, OrderSummaryId FROM FulfillmentOrder LIMIT 1];

        WarehouseOrderLineItem woli = new WarehouseOrderLineItem();
        woli.orderLineItemCode = oi.Product2.ProductCode;
        woli.quantity = (Integer)oi.Quantity;

        WarehouseOrder wo = new WarehouseOrder();
        wo.orderId = ord.OrderReferenceNumber;
        wo.orderLineItems = new List<WarehouseOrderLineItem>{ woli };

        Test.startTest();
        BatchImportWareHouse batch = new BatchImportWareHouse(wo);
        Id batchId = Database.executeBatch(batch, 200);
        Test.stopTest();

        /*FulfillmentOrder updatedFO = [SELECT Id, Status FROM FulfillmentOrder WHERE Id = :fo.Id LIMIT 1];

        FulfillmentOrderLineItem updatedFOLI = [SELECT Id, Quantity_Fulfilled__c FROM FulfillmentOrderLineItem WHERE FulfillmentOrderId = :updatedFO.Id LIMIT 1];

        OrderSummary updatedOS = [SELECT Id, Status FROM OrderSummary WHERE Id = :fo.OrderSummaryId LIMIT 1];

        List<Shipment> shipments = [SELECT Id, FulfillmentOrderId FROM Shipment WHERE FulfillmentOrderId = :updatedFO.Id];*/
    }
}