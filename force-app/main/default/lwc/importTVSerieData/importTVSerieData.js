import { LightningElement, track } from 'lwc';
import importTvSerie from '@salesforce/apex/DataImportController.importTvSerie';


export default class ImportTVSerieData extends LightningElement {
    @track tvSerieName = '';
    @track showMessage = false;

    handleInputChange(event) {
        this.tvSerieName = event.target.value;
    }

    importData() {
        importTvSerie({ tvSerieName: this.tvSerieName })
            .then(result => {
                this.showMessage = true;
            })
            .catch(error => {
                console.error(error);
            });
    }
}
