import { LightningElement, wire, track } from 'lwc';
import getAccoWithCon from '@salesforce/apex/AccountController.getAccoWithCon';

export default class AccountTreeGrid extends LightningElement {
    @track gridData = [];
    columns = [
        { label: 'Name', fieldName: 'name', type: 'text' },
        { label: 'Employees', fieldName: 'NumberOfEmployees', type: 'number' },
        { label: 'Phone Number', fieldName: 'Phone', type: 'Phone' },
        { label: 'Billing City', fieldName: 'BillingAddress', type: 'Address' }
    ];

    @wire(getAccoWithCon )
    wiredAccounts({ error, data }) {
        if (data) {
            this.gridData = this.formatData(data);
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    formatData(accounts) {
        return accounts.map(account => {
            let children = (account.Contacts && Array.isArray(account.Contacts)) 
                ? account.Contacts.map(contact => ({
                    id: contact.Id,
                    name: contact.Name,
                    email: contact.Email || 'N/A', // Handle missing email
                    _children: []
                })) 
                : [];
            return {
                id: account.Id,
                name: account.Name,
                NumberOfEmployees:account.NumberOfEmployees,
                Phone:account.Phone,
                BillingAddress:account.BillingAddress,
                _children: children
            };
        });
    }
}