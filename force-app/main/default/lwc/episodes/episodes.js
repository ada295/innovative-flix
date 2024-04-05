import getAllEpisodesBySeasonId from '@salesforce/apex/EpisodeController.getAllEpisodesBySeasonId';
import { LightningElement, wire, api, track } from 'lwc';

export default class Episodes extends LightningElement {
    @api seasonId;
    @api currentPage;
    episodes=[];
    @track
    isToMany = false;
    MAX_EPISODES_IN_LIST = 10;

    // renderedCallback() {
    //     if (this.seasonId) {
    //         getAllEpisodesBySeasonId({ seasonId: this.seasonId })
    //             .then(result => {
    //                 this.episodes = result;
    //             })
    //             .catch(error => {
    //                 console.error(error);
    //             });
    //     }
    //     console.log('connect execution');
    // }

    @wire(getAllEpisodesBySeasonId, { seasonId: '$seasonId', page: '$currentPage' })
    wiredEpisodes({ error, data }) {
        console.log("executed getAllEpisodesBySeasonId");
        if (data) {

            this.episodes = [];

            if(data.length > this.MAX_EPISODES_IN_LIST) {
                this.isToMany = true;
            }

            // console.log("Fetched ", data.length, " episodes");

            for(let i = 0; i < this.MAX_EPISODES_IN_LIST && i < data.length; i++) {
                this.episodes.push(data[i]);
                
            }
            this.episodes = JSON.parse(JSON.stringify(data));
            console.log("All:", this.template.querySelectorAll('.episode-summary'));
            console.log("bez All:", this.template.querySelector('.episode-summary'));
            // for(let i = 0; i < this.MAX_EPISODES_IN_LIST && i < data.length; i++) {
            //     this.template.querySelectorAll('.episode-summary')[i].innerHTML = this.episodes[i].Summary__c;
            // }


        } else if (error) {
            console.error(error);
        }
    }
}