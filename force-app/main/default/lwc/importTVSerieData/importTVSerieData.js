import { LightningElement, track } from 'lwc';
import importTvSerieById from '@salesforce/apex/DataImportController.importTvSerieById';
import search from '@salesforce/apex/DataImportController.search';


export default class ImportTVSerieData extends LightningElement {
    @track tvSerieName = '';
    @track showMessage = false;
    @track error = '';
    tvSeriesFromSearch = [];

    handleInputChange(event) {
        this.tvSerieName = event.target.value;
    }

    search() {
        this.showMessage = false;
        this.error = '';
        search({ tvSerieName: this.tvSerieName })
            .then(result => {
                this.tvSeriesFromSearch = result;
                console.log(result);
            })
            .catch(exception => {
                this.error = exception.body.pageErrors[0].message;
            });
    }

    importData(event) {
        this.showMessage = false;
        this.error = '';
        let tv = this.tvSeriesFromSearch[event.currentTarget.dataset.index];
        //only id is sent beacuse salesforce does not support SIMPLE DTO as input....
        importTvSerieById({ id: tv.id})
            .then(result => {
                this.showMessage = true;
            })
            .catch(exception => {
                // console.log(exception.body.pageErrors[0].message);
                this.error = exception.body.pageErrors[0].message;
            });
    }
}