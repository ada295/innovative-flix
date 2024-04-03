import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import getTvSerieDetails from '@salesforce/apex/TVSerieController.getTvSerieDetails';

export default class TvSerieDetails extends NavigationMixin(LightningElement) {
    tvSerieId;
    tvSerie = {};

    @wire(CurrentPageReference) pageRef; //contains page params

    connectedCallback() { //runs on initialization
        const state = this.pageRef && this.pageRef.state;
        console.log("tvSerie", state.id);
        this.tvSerieId = state.id;
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/03/2024
     * @description The method get TVSerie's details
     * 
     * @param tvSerieId
     */
    @wire(getTvSerieDetails, { tvSerieId: '$tvSerieId' })
    tvSerieDetails({ error, data }) {
        if (data) {
            this.tvSerie = JSON.parse(JSON.stringify(data));
            if(this.tvSerie.Trailer__c && this.tvSerie.Trailer__c.includes("watch?v=")) {
                this.tvSerie.Trailer__c = this.tvSerie.Trailer__c.replace("watch?v=","embed/");
            }
            this.template.querySelector('.tv-serie-description').innerHTML = this.tvSerie.Description__c;
        } else if (error) {
            console.error('Error loading TV Serie:', error);
        }
    }

    // handletvSerieClick(event){
    //     const tvSerieId = event.currentTarget.dataset.id;
    //     // this.tvSerieId = tvSerieId; 
    //     // console.log('TV Serie Id: ' + event.currentTarget.dataset.id);  
    //     this.navigateToTVSeriePage(event.currentTarget.dataset.id);   
    // }

    // navigateToTVSeriePage(id) {
    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: '/tvseriesdetails?id=' + id
    //         }
    //     });
    // }
}