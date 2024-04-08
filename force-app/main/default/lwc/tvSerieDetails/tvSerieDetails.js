import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import getTvSerieDetails from '@salesforce/apex/TVSerieController.getTvSerieDetails';
import getRandomTvSerieDetails from '@salesforce/apex/TVSerieController.getRandomTvSerieDetails';

export default class TvSerieDetails extends NavigationMixin(LightningElement) {
    @track tvSerieId;
    tvSerie = {};
    error;

    @wire(CurrentPageReference) pageRef; //contains page params

    connectedCallback() { //runs on initialization
        const state = this.pageRef && this.pageRef.state;
        console.log("tvSerie", state.id);
        if(state.id.includes('random')) {
            getRandomTvSerieDetails()
                .then(result => {
                    this.tvSerieId = result;
                    this.loadDetails();
                })
                .catch(error => {
                    console.error('Error fetching TV Series:', error);
                });
        } else {
            this.tvSerieId = state.id;
            this.loadDetails();
        }
    }

    loadDetails() {
        getTvSerieDetails({tvSerieId: this.tvSerieId})
            .then(data => {
                if (data) {
                    this.tvSerie = JSON.parse(JSON.stringify(data));
                    if(this.tvSerie.Trailer__c && this.tvSerie.Trailer__c.includes("watch?v=")) {
                        this.tvSerie.Trailer__c = this.tvSerie.Trailer__c.replace("watch?v=","embed/");
                    
                    }
                    this.tvSerie.Trailer__c = this.tvSerie.Trailer__c + '?autoplay=1&mute=1';
                    this.template.querySelector('.tv-serie-description').innerHTML = this.tvSerie.Summary__c;
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    resizeIframe() {
        const iframe = this.template.querySelector('.responsive-iframe');
        if (iframe) {
            const height = iframe.contentWindow.document.body.scrollHeight + 'px';
            iframe.style.height = height;
        }
    }

    get tvSerieRating(){
        if(this.tvSerie && this.tvSerie.Rating__c != null && this.tvSerie.Rating__c != undefined){
            let rating = this.tvSerie.Rating__c.toString();

            if (rating.includes('.')) {
                let parts = rating.split('.');
                let totalPart = parts[0];
                let fractionalPart = parts[1].substring(0, 2);
                rating = totalPart + '.' + fractionalPart;
            }
            return rating;
        } return '';
    }  
}