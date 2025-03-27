public class CancelAction {
    public class CancelWrapper {
        @InvocableVariable(label = 'ChangeOrderId' description = 'Variable' required = true)
        public String ChangeOrderId;
    }

    @InvocableMethod(label = 'ActionCancel' description = 'Cancel Action Apex Method')
    public static void ActionCancel(List<CancelWrapper> cancelWrapper) {
        System.debug('### ActionCancel Method Invoked ###');

        System.debug('### cancelWrapper List: ' + cancelWrapper);

        ExternalData.ExternalDataMethod(cancelWrapper[0].ChangeOrderId, 'Cancel');

        System.debug('### ExternalDataMethod Called with ChangeOrderId: ' + cancelWrapper[0].ChangeOrderId);
    }
}