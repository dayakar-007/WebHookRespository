import { LightningElement, track } from 'lwc';

export default class Navbar extends LightningElement {
    @track contentShow = {
        Home: true,
        Accounts: false,
        Contacts: false
    };

    setActiveTab(event) {
        console.log('🔄 Switching Tab:', event.target.title);
        console.log('🚀 Before Update:', JSON.stringify(this.contentShow));

        // Reset all tabs to false
        Object.keys(this.contentShow).forEach(key => {
            this.contentShow[key] = false;
        });

        // Activate the selected tab
        this.contentShow[event.target.title] = true;

        console.log('✅ After Update:', JSON.stringify(this.contentShow));
    }

    showHome(event) {
        console.log('🏠 Clicked: Home');
        console.log(event.target.title);
        this.setActiveTab(event.target.title);
    }

    showAccounts(event) {
        console.log('📂 Clicked: Accounts');
        this.setActiveTab(event.target.title);
    }

    showContacts(event) {
        console.log('👤 Clicked: Contacts');
        this.setActiveTab(event.target.title);
    }
}