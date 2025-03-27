public class InventoryReservationHelper {
    public String skuCode{get;set;}
    public String quantity{get;set;}
    public InventoryReservationHelper(String skuCode, String quantity) {
            this.skuCode = skuCode;
            this.quantity = quantity;
        }
}