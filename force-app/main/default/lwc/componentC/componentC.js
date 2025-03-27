import { LightningElement } from 'lwc';

export default class ComponentC extends LightningElement {
    handleOnClick() {
        // Retrieve the input value
        const input = this.template.querySelector('[data-id="text-input"]').value;
        console.log(input);

        // Dispatch a custom event with the input value
        const customEvent = new CustomEvent('componentc', {
            detail: { input: input },
        });

        console.log('Event dispatched successfully');
        this.dispatchEvent(customEvent);
    }
}