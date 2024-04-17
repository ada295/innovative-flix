import getAllSeasonsByTvSerieId from '@salesforce/apex/SeasonController.getAllSeasonsByTvSerieId';
import { LightningElement, api, track, wire } from 'lwc';

export default class Seasons extends LightningElement {
    @api tvSerieId;
    @track seasons=[];
    showEpisodes = false;
    error;
    seasonsLoaded = false;

    handleRatingUpdate(event) {
        this.seasons[event.detail.seasonIndex].Rating__c = event.detail.seasonRating;
    }

    renderedCallback() {
        if(!this.seasonsLoaded) {
            this.loadSeasons();
        }
    }

    loadSeasons() {
        getAllSeasonsByTvSerieId({ tvSerieId: this.tvSerieId })
        .then(data => {
         if (data) {
             this.seasons = JSON.parse(JSON.stringify(data));
             for(let i = 0; i < this.seasons.length; i++) {
                 this.seasons[i].isVisible = false;            
                 this.seasons[i].currentPage = 1;            
             }
             if(this.seasons.length > 0) {
                this.seasonsLoaded = true;
             }
         }
        })
        .catch(exception => {
            this.error = exception.body.pageErrors[0].message;
        });
    }

    connectedCallback() { 
        this.loadSeasons();
    }

    handleSeasonClick(event) {
        this.selectedSeasonId = event.currentTarget.dataset.id;
        let index = event.currentTarget.dataset.index;
        console.log('Click on Season Button id = ' + this.selectedSeasonId);
        this.seasons[index].isVisible = !this.seasons[index].isVisible;
        console.log("data-index-season: ", index, this.seasons[index]);
    }
}