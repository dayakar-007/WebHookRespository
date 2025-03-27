import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {

        obj = {
            fname:'dayakar',
            last:'Reddy',
            age:'20'
        }
        flag = false;

        toggle(event) {
            this.flag = event.target.checked;
        }

        //
        arr = [1,2,3,4,5,6,7,8,9];
}