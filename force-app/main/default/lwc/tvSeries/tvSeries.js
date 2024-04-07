import { LightningElement, api, track, wire } from 'lwc';
import getAllTvSeriesByCategoryId from '@salesforce/apex/TVSerieController.getAllTvSeriesByCategoryId';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class TvSeries extends NavigationMixin(LightningElement) {
    @api
    categoryId;
    tvSeries = [];
    @track
    audioElement = {};

    @wire(CurrentPageReference) pageRef; //contains page params

    error;

    connectedCallback() { 
        const state = this.pageRef && this.pageRef.state;
        console.log("categoryId", state.id);
        this.categoryId = state.id;
        getAllTvSeriesByCategoryId({ categoryId: this.categoryId })
           .then(data => {
            if (data && data.length > 0) {
                this.tvSeries = [];
                for(let i=0; i < data.length; i++) {
                    let tvSerie = JSON.parse(JSON.stringify(data[i]));
                    console.log(tvSerie);
                    tvSerie.ImgStyle = "background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url("+tvSerie.Logo__c+")";
                    this.tvSeries.push(tvSerie);
                }    
            }
           })
           .catch(exception => {
               this.error = exception.body.pageErrors[0].message;
           });
    }

    handletvSerieClick(event){
        const tvSerieId = event.currentTarget.dataset.id;
        this.audioElement = {}  
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