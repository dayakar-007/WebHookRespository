import { LightningElement ,track} from 'lwc';

export default class ComponentB extends LightningElement {
     username;
    handleCustomEvent(event)
    {
        console.log('catch the custom event sucessfully');
        console.log('event caught is '+event.detail.input);
        this.username=event.detail.input;
        const customEvent = new CustomEvent('componentb', {
            detail: {username:this.username}
            
        });
        this.dispatchEvent(customEvent);
    }
    

}