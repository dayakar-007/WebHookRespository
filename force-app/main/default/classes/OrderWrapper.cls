public class OrderWrapper {
    public String orderId;
    public String level;
    public String accountName;
    public String accountEmail;
    public String orderNumber;
    public String relatedOrderNumber;
    public Decimal totalAmount;
    public Decimal totalTaxAmount;
    public Decimal grandTotalAmount;
    public List<OrderItemWrapper> orderItems = new List<OrderItemWrapper>();

    // Constructor to populate fields
    public OrderWrapper(Order ord,String level) {
        this.orderId = ord.Id;
        this.accountName  =ord.Account.Name;
        this.accountEmail = ord.Account.PersonEmail;
        this.orderNumber = ord.OrderNumber;
        this.relatedOrderNumber = ord.RelatedOrder.OrderNumber;
        this.totalAmount = ord.TotalAmount;
        this.totalTaxAmount = ord.TotalTaxAmount;
        this.grandTotalAmount = ord.GrandTotalAmount;
        this.level = level;

        // Loop through OrderItems and add them to the wrapper
        for (OrderItem item : ord.OrderItems) {
            orderItems.add(new OrderItemWrapper(item));
        }
    }

    // ✅ Corrected: Wrapper for Order Items (with Quantity field)
    public class OrderItemWrapper {
        public String orderName;
        public String orderItemId;
        public String orderItemNumber;
        public Integer quantity;
        public Decimal totalPrice;
        public Decimal totalTaxAmount;

        // Constructor to populate fields
        public OrderItemWrapper(OrderItem item) {
            this.orderName = item.Product2.Name;
            this.orderItemId = item.Id;
            this.orderItemNumber = item.OrderItemNumber;
            this.quantity = (Integer)item.Quantity;
            this.totalPrice = item.TotalPrice;
            this.totalTaxAmount = item.TotalTaxAmount;
        }
    }
}