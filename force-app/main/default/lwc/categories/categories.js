import { LightningElement, track, wire } from 'lwc';
import getAllCategories from '@salesforce/apex/CategoryController.getAllCategories';
import { NavigationMixin } from 'lightning/navigation';


export default class Categories extends NavigationMixin(LightningElement) {
    categories = [];
    @track
    categoryId;
    error;

    connectedCallback() { 
        getAllCategories()
           .then(data => {
            if (data) {
                this.categories = [];
                for(let i=0; i < data.length; i++) {
                    let category = JSON.parse(JSON.stringify(data[i]));
                    category.ImgStyle = "background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url("+category.Image__c+")";
                    this.categories.push(category);
                }
            } else if (error) {
                console.error('Error loading categories:', error);
            }
           })
           .catch(exception => {
               this.error = exception.body.pageErrors[0].message;
           });
    }
   
    handleCategoryClick(event) {
        const categoryId = event.currentTarget.dataset.id;
        this.categoryId = categoryId; 
        this.navigateToCategoryPage(event.currentTarget.dataset.id);   
    }

    handleRandomMovieClick(event) {
        this.navigateToRandomTVDetails();   
    }
    
    handleBestRating(event) {
        this.navigateToBestRating();   
    }

    handleLatestAdded(event) {
        this.navigateToLatestAdded();   
    }

    navigateToBestRating() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/bestrated'
            }
        });
    }

    navigateToLatestAdded() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/latest'
            }
        });
    }
    
    navigateToCategoryPage(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/categorydetails?id=' + id
            }
        });
    }

    navigateToRandomTVDetails() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/tvseriesdetails?id=random'
            }
        });
    }
}