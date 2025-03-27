import { LightningElement, wire } from 'lwc';
import getTopAccounts from '@salesforce/apex/AccountController.getTopAccounts';

export default class TopAccounts extends LightningElement {
    accounts = [];
    error;

    @wire(getTopAccounts)
    handleGetTopAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
            console.log('every thing is fine');
        } else if (error) {
            this.error = error;
            this.accounts = [];
            console.log('error ');;
        }
    }
}