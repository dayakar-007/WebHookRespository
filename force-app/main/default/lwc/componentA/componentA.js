import { LightningElement } from 'lwc';

export default class ComponentA extends LightningElement {
username;
handleCustomEvent(event)
{
    console.log('catch the custom event sucessfully');
     console.log('event caught is '+event.detail.input);
     this.username=event.detail.username;
}

 
}