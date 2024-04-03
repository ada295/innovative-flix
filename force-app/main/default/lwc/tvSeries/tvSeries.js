import { LightningElement, api, track, wire } from 'lwc';
import getAllTvSeriesByCategoryId from '@salesforce/apex/TVSerieController.getAllTvSeriesByCategoryId';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class TvSeries extends NavigationMixin(LightningElement) {
    @api
    categoryId;
    tvSeries = [];

    @wire(CurrentPageReference) pageRef; //contains page params

    connectedCallback() { //runs on TvSeries initialization
        const state = this.pageRef && this.pageRef.state;
        console.log("categoryId", state.id);
        this.categoryId = state.id;
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/03/2024
     * @description The method get all TVSeries By Category Id.
     * 
     * @param categoryId
     */
    @wire(getAllTvSeriesByCategoryId, { categoryId: '$categoryId' }) //categoryId is bounded to the variable and allTVSeries is executed every time value changes
    allTVSeries({ error, data }) {
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
    }

    handletvSerieClick(event){
        const tvSerieId = event.currentTarget.dataset.id;
        // this.tvSerieId = tvSerieId; 
        // console.log('TV Serie Id: ' + event.currentTarget.dataset.id);  
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