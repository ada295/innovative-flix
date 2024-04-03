import { LightningElement, api, wire } from 'lwc';
import getAllTvSeriesByCategoryId from '@salesforce/apex/TVSerieController.getAllTvSeriesByCategoryId';
import { CurrentPageReference } from 'lightning/navigation';
import { invoke } from '@salesforce/apex';

export default class TvSeries extends LightningElement {

    @wire(CurrentPageReference) pageRef; //contains page params

    connectedCallback() { //runs on TvSeries initialization
        const state = this.pageRef && this.pageRef.state;
        console.log("categoryId", state.id);
        this.categoryId = state.id;
    }

    @api
    categoryId;
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/03/2024
     * @description The method get all TVSeries By Category Id.
     * 
     * @param allTVSeries TVSeries of the selected category.
     */
    @wire(getAllTvSeriesByCategoryId, { categoryId: '$categoryId' }) //categoryId is bounded to the variable and allTVSeries is executed every time value changes
    allTVSeries({ error, data }) {
        if (data) {
            this.accounts = data;  
            console.log(data);          
        } else if (error) {
            console.error(error);
        }
    }
}