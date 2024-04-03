import { LightningElement, track, wire } from 'lwc';
import getAllCategories from '@salesforce/apex/CategoryController.getAllCategories';
import { NavigationMixin } from 'lightning/navigation';


export default class Categories extends NavigationMixin(LightningElement) {
    categories = [];
    @track
    categoryId;

    @wire(getAllCategories)
    allCategories({ error, data }) {
        if (data) {
            this.categories = [];
            for(let i=0; i < data.length; i++) {
                let category = JSON.parse(JSON.stringify(data[i]));
                category.ImgStyle = "background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url("+category.Image__c+")";
                this.categories.push(category);
            }
            // console.log(categories);
            // this.categories.forEach((category)=> category.ImgStyle= "background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url("+category.Image__c+")");
        } else if (error) {
            console.error('Error loading categories:', error);
        }
    }

    handleCategoryClick(event) {
        const categoryId = event.currentTarget.dataset.id;
        this.categoryId = categoryId;
        // getTvSeriesByCategoryId({ categoryId })
        //     .then(result => {
        //         this.tvSeries = result;

        //     })
        //     .catch(error => {
        //         console.error(error);
        //     });  
        console.log('Categiry Id: ' + event.currentTarget.dataset.id);  
        this.navigateToCategoryPage(event.currentTarget.dataset.id);   
    }

    navigateToCategoryPage(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/categorydetails?id=' + id
            }
        });
    }
}