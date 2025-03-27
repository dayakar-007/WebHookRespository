import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountsPageSize from '@salesforce/apex/AccountController.getAccountsPageSize';
import updateAccounts from '@salesforce/apex/AccountController.updateAccounts';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import EMPLOYEE_FIELD from '@salesforce/schema/Account.NumberOfEmployees';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import ACCOUNT_OWNER from '@salesforce/schema/Account.OwnerId';
import BillingCity from '@salesforce/schema/Account.BillingAddress';
import CreatedDate from '@salesforce/schema/Account.CreatedDate';
const PAGE_SIZE = 10;
export default class DataTable extends LightningElement {
    @track allAccounts = [];
    @track filteredAccounts = [];
    @track displayedAccounts = [];
    @track currentPage = 1;
    @track totalPages = 1;
    @track totalRecords = 0;
    @track sortBy;
    @track sortDirection = 'asc';
    @track searchKey = '';
    columns = [
        { label: 'Account Name', fieldName: NAME_FIELD.fieldApiName, type: 'text', sortable: true ,editable: true,wrapText:true},
        { label: 'Employees', fieldName: EMPLOYEE_FIELD.fieldApiName, type: 'number', sortable: true,editable: true ,wrapText:true},
        { label: 'Phone', fieldName: PHONE_FIELD.fieldApiName, type: 'phone', sortable: true ,editable: true,wrapText:true},
        { label: 'Account Owner', fieldName: ACCOUNT_OWNER.fieldApiName, type: 'text', sortable: true,editable: true,wrapText:true },
        { label: 'Billing City', fieldName: BillingCity.fieldApiName, type: 'text', sortable: true ,editable: true,wrapText:true},
        { label: 'Created Date', fieldName: CreatedDate.fieldApiName, type: 'text', sortable: true ,editable: false,wrapText:true}
    ];
    connectedCallback() {
        this.fetchAccounts();
    }
    fetchAccounts() {
        console.log('fetchAccounts');
        getAccountsPageSize({ pageNumber: this.currentPage, pageSize: PAGE_SIZE,searchText:this.searchKey})
            .then(result => {
                this.allAccounts = result.accounts;
                this.displayedAccounts = this.allAccounts;
                this.totalRecords = result.totalRecords;
                this.totalPages = Math.max(1, Math.ceil(this.totalRecords / PAGE_SIZE));
            })
            .catch(error => {
                console.error('Error fetching accounts:', error);
                this.isLoading = false;
            });
    }
    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.fetchAccounts();
        }
    }
    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.fetchAccounts();
        }
    }
    get disableNext() {
        return this.currentPage >= this.totalPages;
    }

    get disablePrevious() {
        return this.currentPage <= 1;
    }
    sortAccounts() {
        let sortedData = [...this.allAccounts];
        if (this.sortBy) {
            sortedData.sort((a, b) => {
                let valueA = a[this.sortBy] ?? '';
                let valueB = b[this.sortBy] ?? '';

                if (typeof valueA === 'string') {
                    valueA = valueA.toLowerCase();
                    valueB = valueB.toLowerCase();
                } else if (typeof valueA === 'number' && typeof valueB === 'number') {
                    return this.sortDirection === 'asc' ? valueA - valueB : valueB - valueA;
                }

                return this.sortDirection === 'asc' ? (valueA > valueB ? 1 : -1) : (valueA < valueB ? 1 : -1);
            });
        }

        this.displayedAccounts = [...sortedData];
    }
    handleSort(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        console.log('this.sortDirection',this.sortDirection);
        this.sortAccounts();
    }
    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        console.log('updatedFields',updatedFields);
        updateAccounts({ updatedAccounts: updatedFields })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records updated successfully!',
                        variant: 'success'
                    })
                );
                this.draftValues = []; // Clear draft values
                this.fetchAccounts(); // Refresh table
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error updating records: ' + error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
    handleSearch(event) {
        this.searchKey = event.target.value.trim().toLowerCase();
        console.log('🔍 Search Key:', this.searchKey);
    
        this.fetchAccounts(); // Ensure the latest records are fetched
    
        if (this.searchKey) {
            console.log('🔍 Filtering Records...');
    
            this.filteredAccounts = this.allAccounts.filter(acc => {
                return this.columns.some(column => {
                    let fieldValue = acc[column.fieldName];
    
                    // Handle nested fields like Owner.Name
                    if (column.fieldName.includes('.')) {
                        const fieldParts = column.fieldName.split('.');
                        fieldValue = acc;
                        fieldParts.forEach(part => {
                            if (fieldValue) {
                                fieldValue = fieldValue[part];
                            }
                        });
                    }
    
                    console.log(`🔍 Checking Field: ${column.fieldName}, Value: ${fieldValue}`);
    
                    return fieldValue && fieldValue.toString().toLowerCase().includes(this.searchKey);
                });
            });
    
            console.log('✅ Filtered Records:', JSON.stringify(this.filteredAccounts));
        } else {
            console.log('🔄 Resetting Filter: Showing all records');
            this.filteredAccounts = this.allAccounts;
        }
    
        // Update the displayed accounts
        this.displayedAccounts = [...this.filteredAccounts];
        console.log('📋 Updated Displayed Accounts:', JSON.stringify(this.displayedAccounts));
    }
    
    
}