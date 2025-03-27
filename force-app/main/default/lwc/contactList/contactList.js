import { LightningElement,track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import EMAIL from '@salesforce/schema/Contact.Email';
import { reduceErrors } from 'c/ldsUtils';
export default class ContactList extends LightningElement {
    @track allContacts;
    @track displayedContacts;
    @track currentPage = 1;
    @track totalPages;
    columns = [
        {
            label: 'First Name',
            fieldName: FIRST_NAME.fieldApiName,
            type: 'text',
            sortable:true
        },
        {
            label:'Last Name',
            fieldName :LAST_NAME.fieldApiName,
            type: 'text',
            sortable : true
        },
        {
            label:'Email',
            fieldName :EMAIL.fieldApiName,
            type: 'email',
            sortable : true
        }
    ];
    @wire(getContacts)
    wiredContacts ({error,data}) {
        if(data)
        {
            this.allContacts = data;
        }
        else if(error)
        {
            console.error('Error fetching accounts:', error);
        }
    }
    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}