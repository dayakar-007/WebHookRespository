import { LightningElement ,api, wire} from 'lwc';
import getContacts from'@salesforce/apex/AccountContacts.getContacts';
import deleteContact from'@salesforce/apex/AccountContacts.deleteContact';
import { refreshApex } from '@salesforce/apex';

export default class GetTheAccountID extends LightningElement {

    @api recordId;
    @wire(getContacts, { recordId:'$recordId' }) contacts;


    handleDelete(event){
        const conId = event.target.dataset.id;
        deleteContact({conId})
        .then(()=>{
            console.log('Contact deleted successfully');
                return refreshApex(this.contacts);
        })
        .catch(error=>{
            console.error('Error deleting contact:', error);
        });


    }
    
       
}