import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';

const FIELDS = ['Account.Name', 'Account.Phone'];

export default class WireFetch extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    accounts;

    get getName() {
        if (this.accounts?.data) {
            return getFieldValue(this.accounts.data, 'Account.Name');
        } else if (this.accounts?.error) {
            return this.accounts.error.body.message?.toUpperCase();
        }
        return '';
    }

    get getPhone() {
        if (this.accounts?.data) {
            return getFieldValue(this.accounts.data, 'Account.Phone');
        } else if (this.accounts?.error) {
            return this.accounts.error.body.message?.toUpperCase();
        }
        return '';
    }
}