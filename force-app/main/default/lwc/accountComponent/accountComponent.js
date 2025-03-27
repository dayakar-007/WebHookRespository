import { LightningElement, wire } from 'lwc';
import  getAccount  from '@salesforce/apex/GetAccount.getAccount';

export default class AccountComponent extends LightningElement {

    @wire(getAccount) accounts;
}