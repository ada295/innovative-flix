import getLoggedUserRatingForSeason from '@salesforce/apex/RatingController.getLoggedUserRatingForSeason';
import setLoggedUserRatingForSeason from '@salesforce/apex/RatingController.setLoggedUserRatingForSeason';
import { LightningElement, api, track, wire } from 'lwc';
export default class Rating extends LightningElement {
    @api seasonId;
    edit = false;

    @track
    rating = {};

    points = [
        { value: '1', label: '★☆☆☆☆', description: '' },
        { value: '2', label: '★★☆☆☆', description: '' },
        { value: '3', label: '★★★☆☆', description: '' },
        { value: '4', label: '★★★★☆', description: '' },
        { value: '5', label: '★★★★★', description: '' },
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

    get yourRating() {
        if(this.rating.Points__c != undefined) {
            return this.points[parseInt(this.rating.Points__c) - 1].label;
        }
    }
}