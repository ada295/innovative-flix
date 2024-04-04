import getAllSeasonsByTvSerieId from '@salesforce/apex/SeasonController.getAllSeasonsByTvSerieId';
import { LightningElement, api, track, wire } from 'lwc';

export default class Seasons extends LightningElement {
    @api tvSerieId;
    @track selectedSeasonId;
    // @track selectedPageNumber = 1;
    @track seasons=[];
    showEpisodes = false;

    @wire(getAllSeasonsByTvSerieId,  { tvSerieId: '$tvSerieId' })
    allTvSerieSeasons({ error, data }) {
        if (data) {
            this.seasons = JSON.parse(JSON.stringify(data));
            for(let i = 0; i < this.seasons.length; i++) {
                this.seasons[i].isVisible = false;            
                this.seasons[i].currentPage = 1;            
            }
        } else if (error) {
            console.error(error);
        }
    }

    handleSeasonClick(event) {
        this.selectedSeasonId = event.currentTarget.dataset.id;
        let index = event.currentTarget.dataset.index;
        console.log('Click on Season Button id = ' + this.selectedSeasonId);
        this.seasons[index].isVisible = !this.seasons[index].isVisible;
        console.log("data-index-season: ",index, this.seasons[index]);

        // this.template.querySelector('.episodes-container').innerHTML = 'bla bla bla <c-episodes season-id={selectedSeasonId}></c-episodes>';
        // let container = this.template.querySelector('.episodes-container');

        // let episodesComponent = document.createElement('c-episodes');
        // episodesComponent.setAttribute('season-id', this.selectedSeasonId);

        // container.appendChild(episodesComponent);
    }

    decrementPageNumber(event){
        let season = this.seasons[event.currentTarget.dataset.index];

        if(season.currentPage > 1){
            season.currentPage--;
        } 
        console.log(season.currentPage);
    }

    incrementPageNumber(){
        let season = this.seasons[event.currentTarget.dataset.index];

        season.currentPage++;
        console.log(season.currentPage);
    }

    // numberOfPageNotEquals1(){
    //     console.log('Number of page' + this.selectedPageNumber);
    //     return this.selectedPageNumber != 1;
    // }
}