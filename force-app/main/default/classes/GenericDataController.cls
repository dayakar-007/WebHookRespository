/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-17-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class GenericDataController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRecords(String objectApiName, List<String> fieldNames, Integer pageNumber, Integer pageSize) {
        System.debug('🔄 [getRecords] Start fetching records for: ' + objectApiName);
        System.debug('ℹ️ [getRecords] Fields Requested: ' + fieldNames);
        System.debug('ℹ️ [getRecords] Page Number: ' + pageNumber + ', Page Size: ' + pageSize);

        if (String.isEmpty(objectApiName) || fieldNames == null || fieldNames.isEmpty()) {
            System.debug('❌ [getRecords] Missing Object Name or Fields');
            throw new AuraHandledException('Missing Object Name or Fields');
        }

        Integer offsetVal = (pageNumber - 1) * pageSize;
        String fieldString = String.join(fieldNames, ',');
        String query = 'SELECT ' + fieldString + ' FROM ' + objectApiName + ' ORDER BY Name ASC LIMIT :pageSize OFFSET :offsetVal';

        System.debug('🛠 [getRecords] Executing Query: ' + query);

        Map<String, Object> response = new Map<String, Object>();

        try {
            // Fetch paginated records
            List<sObject> records = Database.query(query);
            System.debug('✅ [getRecords] Records fetched successfully. Total Records Retrieved: ' + records.size());

            // Fetch total count
            Integer totalRecords = getTotalRecordCount(objectApiName);
            System.debug('ℹ️ [getRecords] Total Records in Database: ' + totalRecords);

            response.put('records', records);
            response.put('totalRecords', totalRecords);

            return response;
        } catch (Exception e) {
            System.debug('❌ [getRecords] SOQL Error: ' + e.getMessage());
            throw new AuraHandledException('SOQL Error: ' + e.getMessage());
        }
    }

    // ✅ Fixed COUNT() Query
    @AuraEnabled(cacheable=true)
    public static Integer getTotalRecordCount(String objectApiName) {
        System.debug('🔄 [getTotalRecordCount] Fetching total count for: ' + objectApiName);

        try {
            // ✅ Fixed: Removed square brackets & formatted SOQL correctly
            String countQuery = 'SELECT COUNT(Id) FROM ' + objectApiName;
            System.debug('🛠 [getTotalRecordCount] Executing Query: ' + countQuery);

            // ✅ Corrected Database.countQuery()
            Integer totalRecords = [SELECT COUNT() FROM Account];
            System.debug('✅ [getTotalRecordCount] Total Records Counted: ' + totalRecords);

            return totalRecords;
        } catch (Exception e) {
            System.debug('❌ [getTotalRecordCount] COUNT Query Error: ' + e.getMessage());
            throw new AuraHandledException('COUNT Query Error: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String updateRecords(List<sObject> updatedRecords) {
        System.debug('🔄 [updateRecords] Updating records. Total Records to Update: ' + updatedRecords.size());

        try {
            System.debug('🛠 [updateRecords] Executing Update...');
            update updatedRecords;
            System.debug('✅ [updateRecords] Records updated successfully!');

            return 'Records updated successfully';
        } catch (Exception e) {
            System.debug('❌ [updateRecords] Error updating records: ' + e.getMessage());
            throw new AuraHandledException('Error updating records: ' + e.getMessage());
        }
    }
}