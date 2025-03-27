public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accIds) {
        // Map to store the count of contacts for each account
        Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();

        // Aggregate query to count contacts grouped by AccountId
        List<AggregateResult> aggResults = [
            SELECT AccountId, COUNT(Id) totalContacts
            FROM Contact
            WHERE AccountId IN :accIds
            GROUP BY AccountId
        ];

        // Populate the map with AccountId and Contact Count
        for (AggregateResult agg : aggResults) {
            accountContactCounts.put(
                (Id)agg.get('AccountId'),
                (Integer)agg.get('totalContacts')
            );
        }

        // Prepare a list of accounts to update
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accIds) {
            Integer contactCount = accountContactCounts.containsKey(accountId)
                ? accountContactCounts.get(accountId)
                : 0;
            accountsToUpdate.add(new Account(
                Id = accountId,
                Number_Of_Contacts__c = contactCount
            ));
        }

        // Update accounts if there are any to update
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}