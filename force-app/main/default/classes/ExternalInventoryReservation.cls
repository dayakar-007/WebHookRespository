public class ExternalInventoryReservation {
	public class InventoryReservationInput
    {
        @InvocableVariable( label ='CartItemInput' required=true)
        public List<ConnectApi.CartItemInput> cartItemInputs; 
    }
    @InvocableMethod(label = 'External Inventory Check' description = 'External Inventory check method')
    public static List<String> checkReservation(List<InventoryReservationInput> inventoryReservationInput)
    {
        Set<Id> ids = new Set<Id>();
        for(ConnectApi.CartItemInput cartItemInput:inventoryReservationInput[0].cartItemInputs)
        {
            ids.add(cartItemInput.productId);
        }
        return handlecheckReservation(ids,inventoryReservationInput[0].cartItemInputs);
    }
    public static List<String> handlecheckReservation(Set<Id> productIds,List<ConnectApi.CartItemInput> cartItemInputs)
    {
        Map<Id,Product2> productMap = new Map<Id, Product2>([SELECT Id,StockKeepingUnit FROM Product2 WHERE Id IN: productIds]);
        List<InventoryReservationHelper> inventoryReservationHelper = new List<InventoryReservationHelper>();
        for(ConnectApi.CartItemInput cartItemInput:cartItemInputs)
        {
            Id id = cartItemInput.productId;
            String skuCode = productMap.get(id).StockKeepingUnit;
            String quantity = cartItemInput.quantity;
            inventoryReservationHelper.add(new InventoryReservationHelper(skuCode,quantity));
        }
        String jsonserialize = JSON.serialize(inventoryReservationHelper);
        //throught the http callouts we send the information inventory,for check the avaliable to order
        // if recive the sucess responce then again we send the request to make reservation endpoint then sucessfully,we craete the reservation 
        // for product of the cart
        return new List<String>();
    }
    
    
    
   
}