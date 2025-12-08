import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CONTACT_ID_FIELD from "@salesforce/schema/Case.ContactId";
import getProductPricing from '@salesforce/apex/CustomerProductInfoController.getProductPricing';
import HOME_COUNTRY_FIELD from "@salesforce/schema/Contact.Home_Country__c";
import PRODUCT_ID_FIELD from "@salesforce/schema/Contact.Product__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class CustomerProductInfo extends LightningElement {
	@api recordId;
	productURL;
	productInfo;
	@wire(getRecord, { recordId: '$recordId', fields: [CONTACT_ID_FIELD] })
	case;

	get contactId() {
		return getFieldValue(this.case.data, CONTACT_ID_FIELD);
	}
	@wire(getRecord, { recordId: '$contactId', fields: [HOME_COUNTRY_FIELD, PRODUCT_ID_FIELD] })
	contact;

	get homeCountry() {
		return getFieldValue(this.contact.data, HOME_COUNTRY_FIELD);
	}
	get productId() {
		return getFieldValue(this.contact.data, PRODUCT_ID_FIELD);
	}

	@wire(getProductPricing, { productId: '$productId', homeCountry: '$homeCountry' })
	productPricing({ error, data }) {
		if (data) {
			
			this.productURL= '/'+data.productId;
			this.productInfo = data[0];
			console.log('Product Pricing Data:', this.productInfo.product);
		} else if (error) {
			let errorMessage;
			if (error.body.message) {
				errorMessage = error.body.message;
			}
			this.showToast("Failure", errorMessage, "error");
		}
	}

	showToast(title, message, variant) {
		const event = new ShowToastEvent({ title, message, variant });
		this.dispatchEvent(event);
	}
}