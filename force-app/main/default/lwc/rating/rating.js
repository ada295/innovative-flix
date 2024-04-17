import getLoggedUserRatingForSeason from '@salesforce/apex/RatingController.getLoggedUserRatingForSeason';
import getRatingForSeason from '@salesforce/apex/RatingController.getRatingForSeason';
import getRatingForTVSerie from '@salesforce/apex/RatingController.getRatingForTVSerie';
import setLoggedUserRatingForSeason from '@salesforce/apex/RatingController.setLoggedUserRatingForSeason';
import setSeasonsRatingsAndTVSeriesRatings from '@salesforce/apex/RatingController.setSeasonsRatingsAndTVSeriesRatings';
import { LightningElement, api, track, wire } from 'lwc';
export default class Rating extends LightningElement {
    @api seasonId;
    edit = false;

    @track
    rating = {};

    @api
    season;

    @track
    tvSerie = {};

    @api
    seasonIndex;
    

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
                    getRatingForSeason({seasonId: this.seasonId}).then(data => {
                        if(data) {
                            console.log(data);
                            const ratingUpdateEvent = new CustomEvent('ratingupdate', {
                                detail: {
                                    seasonRating: JSON.parse(JSON.stringify(data)).Rating__c,
                                    seasonIndex: this.seasonIndex
                                }
                                
                            });
                            this.dispatchEvent(ratingUpdateEvent);
                        } 
                    })
                    getRatingForTVSerie({seasonId: this.seasonId}).then(data => {
                        if(data) {
                            console.log(data);
                            this.tvSerie = JSON.parse(JSON.stringify(data));
                        } 
                    })
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