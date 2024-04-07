import getLoggedUserRatingForSeason from '@salesforce/apex/RatingController.getLoggedUserRatingForSeason';
import setLoggedUserRatingForSeason from '@salesforce/apex/RatingController.setLoggedUserRatingForSeason';
import { LightningElement, api, track, wire } from 'lwc';
export default class Rating extends LightningElement {
    @api seasonId;
    edit = false;

    @track
    rating = {};

    points = [
        { value: '1', label: '1', description: '' },
        { value: '2', label: '2', description: '' },
        { value: '3', label: '3', description: '' },
        { value: '4', label: '4', description: '' },
        { value: '5', label: '5', description: '' },
    ]

    connectedCallback() {
        this.loadRatings();
    }

    changePointsOnChange(event) {
        this.rating.Points__c = event.detail.value;
    }

    updateRating() {
        if (this.seasonId) {
            console.log("updateRating");
            setLoggedUserRatingForSeason({ seasonId: this.seasonId, points: this.rating.Points__c})
                .then(result => {
                    this.edit = false;
                })
                .catch(error => {
                    console.error(error);
                    this.edit = false;
                });
        }
    }

    loadRatings() {
        this.rating = {};
        getLoggedUserRatingForSeason({seasonId: this.seasonId}).then(data => {
            if(data) {
                console.log(data);
                this.rating = JSON.parse(JSON.stringify(data));
            } 
        })
    }

    startEditing(){
        this.edit = true;
    }

    get isRatingPoints() {
        return this.rating.Points__c != undefined;
    }
}