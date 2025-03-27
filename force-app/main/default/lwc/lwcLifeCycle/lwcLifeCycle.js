import { api, LightningElement, track } from 'lwc';

export default class LwcLifeCycle extends LightningElement {

@api count = 0;
handleClick() {
    this.count++;
}
renderedCallback() {
    console.log('renderCallBack'+1);
    
}

}