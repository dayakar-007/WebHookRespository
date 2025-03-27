global without sharing class AllocationJobRunner implements Schedulable
{
    Integer m_intervalMinutes = 5;
    Boolean m_doReschedule = true;
    Boolean m_SystemEnabled = false;
    Boolean m_LookupIntervalMinutes = false;
    
    // Standard time interval from schedulable job
    public AllocationJobRunner(Integer p_intervalMinutes) {
        System.debug('### AllocationJobRunner Constructor: Interval Minutes = ' + p_intervalMinutes);
        this.m_intervalMinutes = p_intervalMinutes;
        init();
    }
    
    // Reschedule and standard time interval from schedulable job
    public AllocationJobRunner(Integer p_intervalMinutes, Boolean p_doReschedule) {
        System.debug('### AllocationJobRunner Constructor: Interval Minutes = ' + p_intervalMinutes + ', Do Reschedule = ' + p_doReschedule);
        this.m_intervalMinutes  = p_intervalMinutes;
        this.m_doReschedule = p_doReschedule;
        init();
    }
    
    // Default time interval
    public AllocationJobRunner() {
        System.debug('### AllocationJobRunner Constructor: Default Constructor Called');
        init();
    }
    
    // Dynamic time interval from Custom Metadata Type
    public AllocationJobRunner(Boolean p_lookupIntervalMinutes) {
        System.debug('### AllocationJobRunner Constructor: Lookup Interval Minutes = ' + p_lookupIntervalMinutes);
        this.m_LookupIntervalMinutes  = p_lookupIntervalMinutes;
        init();
    }
    
    private void init() {
        System.debug('### Module = AllocationJobRunner.init()');
        
        List<AllocationJobSetting__mdt> lAllocSettings = [
            SELECT Id, Label, jobIntervalMinotes__c, customerRemorsePeriodMinutes__c, systemEnable__c 
            FROM AllocationJobSetting__mdt 
            WHERE Label = 'Default Remorse Period' 
            LIMIT 1
        ];
        
        if (lAllocSettings.isEmpty()) {
            System.debug('### ERROR: No AllocationJobSetting__mdt record found!');
            return;
        }

        System.debug('### Retrieved Allocation Settings: ' + lAllocSettings);
        
        if (this.m_LookupIntervalMinutes) {
            this.m_intervalMinutes = lAllocSettings[0].jobIntervalMinotes__c.intValue();
            System.debug('### Interval Minutes Set from Metadata: ' + this.m_intervalMinutes);
        }
        
        this.m_SystemEnabled = lAllocSettings[0].systemEnable__c;
        System.debug('### System Enabled Flag: ' + this.m_SystemEnabled);
    }

    public void execute(SchedulableContext sc) {
        System.debug('### Execution Started: AllocationJobRunner.execute()');
        System.debug('### Interval Minutes: ' + this.m_intervalMinutes);
        System.debug('### Do Reschedule: ' + this.m_doReschedule);
        System.debug('### Lookup Interval Minutes: ' + this.m_LookupIntervalMinutes);
        
        if (this.m_doReschedule) {
            System.debug('### Rescheduling Job...');
            
            // Construct the cron expression for re-scheduling the job
            DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(this.m_intervalMinutes);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                                nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                                nextRunTime.month() + ' ? ' + nextRunTime.year();
            
            System.debug('### Next Run Time: ' + nextRunTime);
            System.debug('### Generated Cron String: ' + cronString);
            
            if (this.m_LookupIntervalMinutes) {
                System.schedule(
                    AllocationJobRunner.class.getName() + '-' + now.format(),
                    cronString,
                    new AllocationJobRunner(this.m_LookupIntervalMinutes)
                );
            } else {
                System.schedule(
                    AllocationJobRunner.class.getName() + '-' + now.format(),
                    cronString,
                    new AllocationJobRunner(m_intervalMinutes)
                );
            }
        }

        Id jobId = sc.getTriggerId();
        System.debug('### Aborting Current Schedule: Job ID = ' + jobId);
        System.abortJob(jobId);

        List<AsyncApexJob> jobs = [
            SELECT Id 
            FROM AsyncApexJob 
            WHERE JobType = 'BatchApex' 
                AND (status = 'Queued' OR status = 'Processing' OR status = 'Preparing')
                AND ApexClassId IN (SELECT Id FROM ApexClass WHERE Name='AllocationBatchJob')
        ];
        
        System.debug('### Existing Allocation Batch Jobs: ' + jobs);
        System.debug('### System Enabled: ' + this.m_SystemEnabled);
        System.debug('### Batch Jobs Count: ' + jobs.size());

        if (this.m_SystemEnabled && jobs.isEmpty()) {
            System.debug('### Executing AllocationBatchJob...');
            Database.executeBatch(new AllocationBatchJob());
        } else {
            System.debug('### Skipping AllocationBatchJob Execution (Either System Disabled or Batch Already Running)');
        }
    }
}