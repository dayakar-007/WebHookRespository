import { LightningElement, track } from 'lwc';

export default class TrackCounter extends LightningElement {
    @track person = { firstName: 'John', lastName: 'Doe' };

    updateFirstName() {
        this.person.firstName = 'Jane'; // The UI won't reflect this change!
    }
}