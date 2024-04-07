import getAllEpisodesBySeasonId from '@salesforce/apex/EpisodeController.getAllEpisodesBySeasonId';
import { LightningElement, wire, api, track } from 'lwc';

export default class Episodes extends LightningElement {
    @api seasonId;
    @api currentPage = 1;
    @api allPages = 1;
    episodes=[];
    @track
    isToMany = false;
    MAX_EPISODES_IN_LIST = 10;

    renderedCallback() {
    }

    loadEpisodes() {
        if (this.seasonId) {
            getAllEpisodesBySeasonId({ seasonId: this.seasonId, page: this.currentPage })
                .then(result => {
                    this.processEpisodes(result);
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }

    error;

    connectedCallback() { 
        this.loadEpisodes();
    }

    processEpisodes(data) {
        console.log("executed getAllEpisodesBySeasonId");
        console.log("duta: ", data);
        if (data && data.episodes) {
            this.episodes = [];
            if(data.episodes.length > this.MAX_EPISODES_IN_LIST) {
                this.isToMany = true;
            }

            this.allPages = data.allPages;

            // console.log("Fetched ", data.length, " episodes");

            for(let i = 0; i < this.MAX_EPISODES_IN_LIST && i < data.episodes.length; i++) {
                this.episodes.push(JSON.parse(JSON.stringify(data.episodes[i])));
            }

            // this.episodes = JSON.parse(JSON.stringify(data));
            // console.log("All:", this.template.querySelectorAll('.episode-summary'));
            // console.log("bez All:", this.template.querySelector('.episode-summary'));
            // for(let i = 0; i < this.MAX_EPISODES_IN_LIST && i < data.length; i++) {
            //     this.template.querySelectorAll('.episode-summary')[i].innerHTML = this.episodes[i].Summary__c;
            // }


        }
    }

    decrementPageNumber(event){
        if(this.currentPage > 1){
            this.currentPage--;
            this.loadEpisodes();
        } 
    }

    incrementPageNumber(){
        if(!this.isLastPage()) {
            this.currentPage++;
            this.loadEpisodes();
        }
    }

    isLastPage() {
        return this.currentPage == this.allPages;
    }

    get isNoMorePages() {
        return this.isLastPage();
    }

    // get getCurrentPage() {
    //     return this.currentPage;
    // }
}