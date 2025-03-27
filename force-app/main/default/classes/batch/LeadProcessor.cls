public with sharing class LeadProcessor implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Start method executed');
        return Database.getQueryLocator([SELECT Id, LeadSource FROM Lead]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        System.debug('Execute method called with scope size: ' + scope.size());
        for (Lead L : scope) {
            L.LeadSource = 'Dreamforce';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch execution completed');
    }
}