public class CancelOrderEmailSender {
    public static void sendEmail(Order changeOrder, String recipientEmail, String level) {
        if (changeOrder == null || String.isEmpty(recipientEmail)) {
            System.debug('No data or invalid recipient email.');
            return;
        }

        // Get the name of the user who placed the order
        String userName = changeOrder.Account.Name;
        System.debug('### Order placed by: ' + userName);

        // Build Email Body Dynamically
        String emailBody = '<html><body>';
        emailBody += '<h2>Order ' + level + ' Confirmation</h2>';
        
        // Section: Order Placed By
        emailBody += '<p><strong>Order Placed By: </strong>' + userName + '</p>';

        // Section 1: Product Information
        emailBody += '<h3>' + level + ' Products</h3><table border="1" cellpadding="5">';
        emailBody += '<tr><th>Product Name</th><th>Quantity</th><th>Tax Amount</th><th>Total Price</th></tr>';
        for (OrderItem orderItem : changeOrder.OrderItems) {
            emailBody += '<tr>';
            emailBody += '<td>' + orderItem.Product2.Name + '</td>';
            emailBody += '<td>' + orderItem.Quantity + '</td>';
            emailBody += '<td>' + orderItem.TotaltaxAmount + '</td>';
            emailBody += '<td>' + orderItem.TotalPrice + '</td>';
            emailBody += '</tr>';
        }
        emailBody += '</table>';

        // Section 2: Financial Summary
        emailBody += '<h3>Financial Summary</h3><table border="1" cellpadding="5">';
        emailBody += '<tr><td>Total Amount</td><td>' + changeOrder.TotalAmount + '</td></tr>';
        emailBody += '<tr><td>Total Tax</td><td>' + changeOrder.TotalTaxAmount + '</td></tr>';
        emailBody += '<tr><td>Grand Total</td><td>' + changeOrder.GrandTotalAmount + '</td></tr>';
        emailBody += '</table>';

        emailBody += '<p>We are sorry for the inconvenience. If you have any questions, please contact our support team.</p>';
        emailBody += '<p>Thank you for shopping with us!</p>';
        emailBody += '</body></html>';

        // Create and send email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{recipientEmail});
        email.setSubject('Your Order ' + level + ' Confirmation');
        email.setHtmlBody(emailBody);
        email.setSaveAsActivity(false);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});

        System.debug('### Email sent to ' + recipientEmail + ' with level: ' + level);
    }
}