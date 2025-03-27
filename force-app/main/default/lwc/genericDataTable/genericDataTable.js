import { LightningElement, api, wire, track } from 'lwc';
import getRecords from '@salesforce/apex/GenericDataController.getRecords';
import updateRecords from '@salesforce/apex/GenericDataController.updateRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const PAGE_SIZE = 10; // Number of records per page

export default class GenericDataTable extends LightningElement {
    @api objectApiName = 'Account'; // Default object
    @api fieldNames = 'Name, Phone, BillingCity'; // Default fields

    @track records = [];
    @track displayedRecords = []; // Records that will be displayed after filtering
    @track columns = [];
    @track sortedBy;
    @track sortedDirection = 'asc';
    @track draftValues = [];
    @track totalRecords = 0;
    @track currentPage = 1;
    @track totalPages = 1;
    @track searchKey = ''; // Stores the search keyword

    get fieldList() {
        return this.fieldNames ? this.fieldNames.split(',').map(field => field.trim()) : [];
    }

    @wire(getRecords, {
        objectApiName: '$objectApiName',
        fieldNames: '$fieldList',
        pageNumber: '$currentPage',
        pageSize: PAGE_SIZE
    })
    wiredRecords({ error, data }) {
        if (data) {
            this.records = data.records.map(record => {
                let row = { Id: record.Id };
                this.fieldList.forEach(field => {
                    row[field] = record[field];
                });
                return row;
            });

            this.totalRecords = data.totalRecords;
            this.totalPages = Math.max(1, Math.ceil(this.totalRecords / PAGE_SIZE));

            this.columns = this.fieldList.map(field => ({
                label: field.replace('_', ' ').toUpperCase(),
                fieldName: field,
                type: field.toLowerCase().includes('date') ? 'date' : 'text',
                editable: true,
                sortable: true,
                wrapText: true
            }));

            // Apply search filter if there is a search key
            this.filterRecords();
        }
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;

        let sortedData = [...this.displayedRecords];
        sortedData.sort((a, b) => {
            let valA = a[this.sortedBy] ? a[this.sortedBy] : '';
            let valB = b[this.sortedBy] ? b[this.sortedBy] : '';

            return this.sortedDirection === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA);
        });

        this.displayedRecords = sortedData;
    }

    

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        console.log('Updated Fields:', updatedFields);
    
        updateRecords({ updatedRecords: updatedFields })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records updated successfully!',
                        variant: 'success'
                    })
                );
                this.draftValues = []; // Clear draft values
                return this.refreshData(); // ✅ Correct method to refresh data
            })
            .catch(error => {
                console.error('❌ Error updating records:', error);
            });
    }
    

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    get disableNext() {
        return this.currentPage >= this.totalPages;
    }

    get disablePrevious() {
        return this.currentPage <= 1;
    }

    // ✅ Search Functionality
    handleSearch(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.filterRecords();
    }

    filterRecords() {
        if (this.searchKey) {
            this.displayedRecords = this.records.filter(record => {
                return this.columns.some(column => {
                    let fieldValue = record[column.fieldName];

                    // Handle nested fields like Owner.Name
                    if (column.fieldName.includes('.')) {
                        const fieldParts = column.fieldName.split('.');
                        fieldValue = record;
                        fieldParts.forEach(part => {
                            if (fieldValue) {
                                fieldValue = fieldValue[part];
                            }
                        });
                    }

                    return fieldValue && fieldValue.toString().toLowerCase().includes(this.searchKey);
                });
            });
        } else {
            this.displayedRecords = [...this.records];
        }
    }
}