import { LightningElement, api, track, wire } from 'lwc';
import getFulfillmentLines from '@salesforce/apex/FulfillmentHelper.getFulfillmentLines';
import updateFulfillmentLineItems from '@salesforce/apex/FulfillmentHelper.updateFulfillmentLineItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ManualFulfillment extends LightningElement {
    @api recordId;
    @track fulfillmentLines = [];
    @track quantityChanges = [];
    @wire(getFulfillmentLines, { fulfillmentId: '$recordId' })
    wiredFulfillmentLines({ error, data }) {
        console.log('🔄 Fulfillment wire called with recordId:', this.recordId);

        if (data) {
            console.log('✅ Fetched fulfillment line items:', data);

            this.fulfillmentLines = data.map((fulfillmentLine, index) => {
                let fulfilled = fulfillmentLine.Quantity_Fulfilled__c;
                if (fulfilled === null || fulfilled === undefined) {
                    fulfilled = 0;
                }
                const remainingQuantity = fulfillmentLine.Quantity - fulfilled;

                console.log(`➡️ Line ${index + 1} (${fulfillmentLine.Description}):`);
                console.log(`   Quantity__c: ${fulfillmentLine.Quantity}`);
                console.log(`   Fulfilled_Quantity__c: ${fulfilled}`);
                console.log(`   Remaining Quantity: ${remainingQuantity}`);

                const options = Array.from({ length: remainingQuantity }, (_, i) => {
                    const labelValue = (i + 1).toString();
                    return { label: labelValue, value: labelValue };
                });

                console.log(`   Picklist Options:`, options);

                return {
                    ...fulfillmentLine,
                    pickListOptions: options,
                    selectedQuantity: null
                };
            });

            console.log('🎯 Final mapped fulfillment lines:', this.fulfillmentLines);

        } else if (error) {
            console.error('❌ Error loading fulfillment lines:', error);
        }
    }

    handleQuantityChange(event) {
        const itemId = event.target.name;
        const selectedValue = event.target.value;
        console.log('🔢 Quantity changed:', itemId, selectedValue);
        const existingIndex = this.quantityChanges.findIndex(item => item.Id === itemId);
        if (existingIndex !== -1) {
            this.quantityChanges[existingIndex].selectedQuantity = selectedValue;
        } else {
            this.quantityChanges.push({ Id: itemId, selectedQuantity: selectedValue });
        }
    
        console.log('📝 Current quantity changes:', JSON.stringify(this.quantityChanges));
    }
    handleCreateShipment(){
        updateFulfillmentLineItems({ linesToUpdate: this.quantityChanges,fulfillmentId: '$recordId'  })
            .then(() => {
        // success toast
            })
            .catch(error => {
                console.error(error);
            });
    }
    get hasQuantityChanges() {
        return this.quantityChanges.length > 0;
    }
}
