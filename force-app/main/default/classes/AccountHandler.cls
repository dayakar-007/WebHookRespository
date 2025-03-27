public  class AccountHandler {
    public static Account insertNewAccount(String name) {
        System.debug('Entering insertAccount method');
        System.debug('Input parameter - name: ' + name);

        Account acc = new Account(Name = name);
        System.debug('Account object created: ' + acc);

        try {
            insert acc;
            System.debug('Account successfully inserted: ' + acc);
            return acc;
        } catch (DmlException e) {
            System.debug('DML Exception occurred: ' + e.getMessage());
            return null;
        }
    }
}