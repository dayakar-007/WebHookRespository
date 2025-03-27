import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController1.getAccounts';
import getContacts from '@salesforce/apex/AccountController1.getContacts';

const ACCOUNT_COLUMNS = [
    { label: 'Account Name', fieldName: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' }, variant: 'base' } },
    { label: 'Employees', fieldName: 'NumberOfEmployees', type: 'number' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Billing City', fieldName: 'BillingCity', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' }
];

const CONTACT_COLUMNS = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];

export default class AccountList extends LightningElement {
    @track accounts = [];
    @track displayedAccounts = [];
    @track contacts = [];
    @track selectedAccount = null;
    @track selectedAccountName = '';
    columns = ACCOUNT_COLUMNS;
    contactColumns = CONTACT_COLUMNS;
    
    // Pagination variables
    currentPage = 1;
    pageSize = 5;
    totalPages = 1;
    
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.totalPages = Math.ceil(data.length / this.pageSize);
            this.updateDisplayedAccounts();
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    updateDisplayedAccounts() {
        const start = (this.currentPage - 1) * this.pageSize;
        this.displayedAccounts = this.accounts.slice(start, start + this.pageSize);
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        let sortedData = [...this.accounts];
        sortedData.sort((a, b) => {
            let valueA = a[fieldName] ? a[fieldName] : '';
            let valueB = b[fieldName] ? b[fieldName] : '';
            return sortDirection === 'asc' ? valueA.localeCompare(valueB) : valueB.localeCompare(valueA);
        });
        this.accounts = sortedData;
        this.updateDisplayedAccounts();
    }

    handleRowAction(event) {
        const accountId = event.detail.row.Id;
        this.selectedAccountName = event.detail.row.Name;
        
        
        // Fetch contacts for the selected account
        getContacts({ accountId })
            .then(data => {
                this.contacts = data;
                if( this.contacts.length >0 )
                {
                    this.selectedAccount = accountId;
                }
                else{
                     this.selectedAccount = null;
                }
            })
            .catch(error => {
                console.error('Error fetching contacts:', error);
            });
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateDisplayedAccounts();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updateDisplayedAccounts();
        }
    }

    get disablePrevious() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages;
    }
}