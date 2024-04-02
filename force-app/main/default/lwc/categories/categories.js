import { LightningElement, wire } from 'lwc';
import getAllCategories from '@salesforce/apex/CategoryController.getAllCategories';


export default class Categories extends LightningElement {
    categories = [];

    @wire(getAllCategories)
    allCategories({ error, data }) {
        if (data) {
            this.categories = data;
        } else if (error) {
            console.error('Error loading categories:', error);
        }
    }
}