import { api, LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/AccountContacts.getContacts';
export default class NoOfContact extends LightningElement {

    @api recordID;

    @wire(getContacts, { accountID: '$recordID' }) result;
    @track ID;

    get getCount() {
        this.ID = this.recordID;
        console.log('Record ID:', this.recordID);
        if (this.result && this.result.data) {
            console.log('Result Data:', this.result.data);
            return this.result.data;
        } else if (this.result && this.result.error) {
            console.log('Error:', this.result.error);
            return 'Error retrieving data';
        }
        return 'Loading...';
    }

    connectedCallback() {
        console.log('Record ID:', this.recordID);
    }
       
}