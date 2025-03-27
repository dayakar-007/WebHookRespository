import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import EMPLOYEE_FIELD from '@salesforce/schema/Account.NumberOfEmployees';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import ACCOUNT_OWNER from '@salesforce/schema/Account.OwnerId';
import BillingCity from '@salesforce/schema/Account.BillingAddress';

const PAGE_SIZE = 10;

export default class AccountList extends LightningElement {
    @track allAccounts = [];
    @track filteredAccounts = [];
    @track displayedAccounts = [];
    @track currentPage = 1;
    @track totalPages = 1;
    @track sortBy;
    @track sortDirection = 'asc';
    rowOffset = 0;
    draftValues = [];

    columns = [
        { label: 'Account Name', fieldName: NAME_FIELD.fieldApiName, type: 'text', sortable: true ,editable: true,wrapText:true},
        { label: 'Employees', fieldName: EMPLOYEE_FIELD.fieldApiName, type: 'number', sortable: true,editable: true ,wrapText:true},
        { label: 'Phone', fieldName: PHONE_FIELD.fieldApiName, type: 'phone', sortable: true ,editable: true,wrapText:true},
        { label: 'Account Owner', fieldName: ACCOUNT_OWNER.fieldApiName, type: 'text', sortable: true,editable: true,wrapText:true },
        { label: 'Billing City', fieldName: BillingCity.fieldApiName, type: 'text', sortable: true ,editable: true,wrapText:true}
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.allAccounts = data;
            this.filteredAccounts = data;
            this.totalPages = Math.max(1, Math.ceil(this.filteredAccounts.length / PAGE_SIZE));
            this.updateDisplayedAccounts();
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updateDisplayedAccounts();
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateDisplayedAccounts();
        }
    }

    updateDisplayedAccounts() {
        const start = (this.currentPage - 1) * PAGE_SIZE;
        const end = start + PAGE_SIZE;

        let sortedData = [...this.filteredAccounts];
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

        this.displayedAccounts = sortedData.slice(start, end);
    }

    handleSort(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.updateDisplayedAccounts();
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();

        if (searchKey) {
            this.filteredAccounts = this.allAccounts.filter(acc => 
                acc.Name?.toLowerCase().includes(searchKey)
            );
        } else {
            this.filteredAccounts = this.allAccounts;
        }

        this.currentPage = 1;
        this.totalPages = Math.max(1, Math.ceil(this.filteredAccounts.length / PAGE_SIZE));
        this.updateDisplayedAccounts();
    }

    get disableNext() {
        return this.currentPage >= this.totalPages;
    }

    get disablePrevious() {
        return this.currentPage <= 1;
    }
    handleSave(event)
    {
        const updateRecords = event.detail.draftValues;
        console.log('updateRecords',updateRecords);
    }
}