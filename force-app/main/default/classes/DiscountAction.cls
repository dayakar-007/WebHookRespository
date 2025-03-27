public class DiscountAction {
    public static String level = '';
    public static String ChangeOrderId = '';

    public class DiscountWrapper {
        @InvocableVariable(label = 'preFulfillmentChangeOrderId' description = 'preFulfillmentChangeOrderId')
        public String preFulfillmentChangeOrderId;

        @InvocableVariable(label = 'postFulfillmentChangeOrderId' description = 'postFulfillmentChangeOrderId')
        public String postFulfillmentChangeOrderId;

        @InvocableVariable(label = 'inFulfillmentChangeOrderId' description = 'inFulfillmentChangeOrderId')
        public String inFulfillmentChangeOrderId;
    }

    @InvocableMethod(label = 'ActionDisCount' description = 'Discount Action Apex Method')
    public static void ActionDisCount(List<DiscountWrapper> discountWrapper) {
        // Debug log when method is invoked
        System.debug('### ActionDisCount method called ###');

        // Debug log for checking if list is null or empty
        if (discountWrapper == null || discountWrapper.isEmpty()) {
            System.debug('### Error: discountWrapper list is null or empty ###');
            return;
        }

        // Log the size of the list
        System.debug('### discountWrapper list size: ' + discountWrapper.size());

        // Log initial values of ChangeOrderId and level
        System.debug('### Initial ChangeOrderId: ' + ChangeOrderId);
        System.debug('### Initial level: ' + level);

        // Check preFulfillmentChangeOrderId
        if (discountWrapper[0].preFulfillmentChangeOrderId != null) {
            System.debug('### preFulfillmentChangeOrderId found: ' + discountWrapper[0].preFulfillmentChangeOrderId);
            ChangeOrderId = discountWrapper[0].preFulfillmentChangeOrderId;
            level = 'preFulfillment';
            System.debug('### Updated ChangeOrderId: ' + ChangeOrderId);
            System.debug('### Updated level: ' + level);
        }

        // Check postFulfillmentChangeOrderId
        if (discountWrapper[0].postFulfillmentChangeOrderId != null) {
            System.debug('### postFulfillmentChangeOrderId found: ' + discountWrapper[0].postFulfillmentChangeOrderId);
            ChangeOrderId = discountWrapper[0].postFulfillmentChangeOrderId;
            level = 'postFulfillment';
            System.debug('### Updated ChangeOrderId: ' + ChangeOrderId);
            System.debug('### Updated level: ' + level);
        }

        // Check inFulfillmentChangeOrderId
        if (discountWrapper[0].inFulfillmentChangeOrderId != null) {
            System.debug('### inFulfillmentChangeOrderId found: ' + discountWrapper[0].inFulfillmentChangeOrderId);
            ChangeOrderId = discountWrapper[0].inFulfillmentChangeOrderId;
            level = 'inFulfillment';
            System.debug('### Updated ChangeOrderId: ' + ChangeOrderId);
            System.debug('### Updated level: ' + level);
        }

        // Log before calling external method
        System.debug('### Calling ExternalDataMethod with ChangeOrderId: ' + ChangeOrderId + ' and level: ' + level);

        // Call the external method
        ExternalData.ExternalDataMethod(ChangeOrderId, level);

        // Log after calling external method
        System.debug('### ExternalDataMethod executed successfully ###');
    }
}