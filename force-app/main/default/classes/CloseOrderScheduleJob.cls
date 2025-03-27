public class CloseOrderScheduleJob implements Schedulable {
    Integer scheduleJobInterval = 5;
    Boolean m_SystemEnabled = false;
    String cornExpression = '';

    public CloseOrderScheduleJob() {
        System.debug('### Constructor Called: CloseOrderScheduleJob');
        init();
    }

    private void init() {
        System.debug('### init() method started');

        // Fetching job interval and system enable flag from custom metadata
        List<AllocationJobSetting__mdt> allocationJobSetting = [
            SELECT Id, Label, jobIntervalMinotes__c, systemEnable__c 
            FROM AllocationJobSetting__mdt 
            WHERE Label = 'Default Remorse Period'
        ];

        if (allocationJobSetting.isEmpty()) {
            System.debug('### ERROR: No AllocationJobSetting__mdt record found with Label "Default Remorse Period"');
            return;
        }

        this.scheduleJobInterval = (Integer) allocationJobSetting[0].jobIntervalMinotes__c;
        this.m_SystemEnabled = allocationJobSetting[0].systemEnable__c;

        System.debug('### scheduleJobInterval: ' + scheduleJobInterval);
        System.debug('### m_SystemEnabled: ' + m_SystemEnabled);

        DateTime now = DateTime.now();
        DateTime nextJobTime = now.addMinutes(scheduleJobInterval);

        this.cornExpression = '' + nextJobTime.second() + ' ' +
                              nextJobTime.minute() + ' ' +
                              nextJobTime.hour() + ' ' +
                              nextJobTime.day() + ' ' +
                              nextJobTime.month() + ' ? ' +
                              nextJobTime.year();

        System.debug('### Generated CRON Expression for rescheduling: ' + cornExpression);
    }

    public void execute(SchedulableContext sc) {
        System.debug('### execute() method started');

        System.debug('### Rescheduling job with CRON expression: ' + cornExpression);
        System.schedule('CloseOrderScheduleJob', cornExpression, new CloseOrderScheduleJob());

        Id jobId = sc.getTriggerId();
        System.debug('### Aborting current scheduled job. Job ID: ' + jobId);
        System.abortJob(jobId);

        System.debug('### Checking for existing AllocationBatchJob running...');

        List<AsyncApexJob> jobs = [
            SELECT Id 
            FROM AsyncApexJob 
            WHERE JobType = 'BatchApex' 
              AND (Status = 'Preparing' OR Status = 'Processing' OR Status = 'Queued') 
              AND ApexClassId IN (SELECT Id FROM ApexClass WHERE Name = 'CloseOrderBatchJob')
        ];

        System.debug('### Found ' + jobs.size() + ' CloseOrderBatchJob(s) in running state.');

        if (this.m_SystemEnabled && jobs.isEmpty()) {
            System.debug('### No existing batch job and system is enabled. Starting CloseOrderBatchJob...');
            Database.executeBatch(new CloseOrderBatchJob());
        } else {
            System.debug('### Skipping CloseOrderBatchJob execution. Either system is disabled or a job is already running.');
        }

        System.debug('### execute() method completed.');
    }
}