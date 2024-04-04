import getAllEpisodesBySeasonId from '@salesforce/apex/EpisodeController.getAllEpisodesBySeasonId';
import { LightningElement, wire, api, track } from 'lwc';

export default class Episodes extends LightningElement {
    @api seasonId;
    episodes=[];
    @track
    isToMany = false;
    MAX_EPISODES_IN_LIST = 3;

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

    @wire(getAllEpisodesBySeasonId, { seasonId: '$seasonId' })
    wiredEpisodes({ error, data }) {
        console.log("executed getAllEpisodesBySeasonId");
        if (data) {
            this.episodes = [];

            if(data.length > this.MAX_EPISODES_IN_LIST) {
                this.isToMany = true;
                for(let i = 0; i < this.MAX_EPISODES_IN_LIST; i++) {
                    console.log(i);
                    console.log(data[i]);
                    this.episodes.push(data[i]);
                }
            }
        } else if (error) {
            console.error(error);
        }
    }

    // closeEpisodesList() {
    //     // event, który zamknie listę odcinków
    //     const closeEvent = new CustomEvent('close');
    //     this.dispatchEvent(closeEvent);
    // }
}