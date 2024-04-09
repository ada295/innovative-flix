import { LightningElement, api, track, wire } from 'lwc';
import getBestRatingTvSeries from '@salesforce/apex/TVSerieController.getBestRatingTvSeries';
import { NavigationMixin } from 'lightning/navigation';

export default class Bestrated extends NavigationMixin(LightningElement) {
    tvSeries = [];

    connectedCallback() { //runs on TvSeries initialization
     getBestRatingTvSeries({maxBestRated: 8})
        .then(data => {
            if (data && data.length > 0) {
                this.tvSeries = [];
                for(let i=0; i < data.length; i++) {
                    let tvSerie = JSON.parse(JSON.stringify(data[i]));
                    console.log(tvSerie);
                    tvSerie.ImgStyle = "background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url("+tvSerie.Logo__c+")";
                    this.tvSeries.push(tvSerie);
                }    
            } else if (error) {
                console.error('Error loading TV Series:', error);
            }
        })
        .catch(exception => {
            this.error = exception.body.pageErrors[0].message;
        });
    }

    handletvSerieClick(event){
        const tvSerieId = event.currentTarget.dataset.id;
        this.navigateToTVSeriePage(event.currentTarget.dataset.id);
    }

    navigateToTVSeriePage(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/tvseriesdetails?id=' + id
            }
        });
    }
}