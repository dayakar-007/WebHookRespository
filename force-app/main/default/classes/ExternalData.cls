public class ExternalData {
    public static String changeOrderId;
    public static String level;

    public static void ExternalDataMethod(String ChangeOrderId, String level) {
        System.debug('### ExternalDataMethod Invoked ###');
        System.debug('### Received ChangeOrderId: ' + ChangeOrderId);
        System.debug('### Received Level: ' + level);

        ExternalData.changeOrderId = ChangeOrderId;
        ExternalData.level = level;

        try {
            Order changeOrder = [SELECT Id, Account.Name,Account.PersonEmail, OrderNumber, RelatedOrder.OrderNumber, 
                                 TotalAmount, TotalTaxAmount, GrandTotalAmount,Data_Recived_SucessFully__c, 
                                 (SELECT Id,Product2.Name, OrderItemNumber, Quantity, TotalPrice, TotaltaxAmount FROM OrderItems) 
                                 FROM Order WHERE Id = :changeOrderId LIMIT 1];
            SendExternalSystem.processExternalSystemData(changeOrder,level);
            System.debug('### Order Retrieved Successfully: ' + changeOrder);
            System.debug('### Order Items Retrived Sucessfullyy'+ changeOrder.OrderItems);
            system.debug('### Account Name'+changeOrder.Account.Name);
            system.debug('### Account Name'+changeOrder.Account.PersonEmail);
            CancelOrderEmailSender.sendEmail(changeOrder,'naraladayakar072@gmail.com',level);
        } catch (Exception e) {
            System.debug('### ERROR: Exception while retrieving Order: ' + e.getMessage());
        }
    }
}