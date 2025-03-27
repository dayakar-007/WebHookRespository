public class ReturnAction {
    public class ReturnrWrapper {
        @InvocableVariable(label = 'ChangeOrderId' description = 'Variable' required = true)
        public String ChangeOrderId;
    }

    @InvocableMethod(label = 'ActionReturn' description = 'Return Action Apex Method')
    public static void ActionReturn(List<ReturnrWrapper> returnrWrapper) {
        // Add debug log to check if method is called
        System.debug('### ActionReturn method called ###');

        // Check if the list is not empty
        if (returnrWrapper == null || returnrWrapper.isEmpty()) {
            System.debug('### Error: returnrWrapper list is null or empty ###');
            return;
        }

        // Log the size of the list
        System.debug('### returnrWrapper list size: ' + returnrWrapper.size());

        // Log the received ChangeOrderId
        System.debug('### ChangeOrderId: ' + returnrWrapper[0].ChangeOrderId);

        // Call the external method
        ExternalData.ExternalDataMethod(returnrWrapper[0].ChangeOrderId, 'Return');

        // Log after calling external method
        System.debug('### ExternalDataMethod called with ChangeOrderId: ' + returnrWrapper[0].ChangeOrderId);
    }
}