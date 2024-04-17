/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 07/04/2024
 * @description This class provides methods for handling TVSeries.
 */
public with sharing class TVSeriesHandler {
     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 08/04/2024
     * @description The method handles logic before insertion or update of TV_Serie records.
     * 
     * @param tvSeries List of new TV_Series records or TV_Serie records with updated data.
     * @param oldTVseries List with data existing TV_Serie records.
     */
    public static void checkUniqueTVSeriesName (List<Tv_Serie__c> tvSeries) {
        if(tvSeries == null){
            return;
        }

        for(Tv_Serie__c tvSerie : tvSeries){
            List<Tv_Serie__c> oldTVseries = [SELECT Name FROM TV_Serie__c
                WHERE Name = :tvSerie.Name AND Id <> :tvSerie.Id];
         
            if(oldTVseries.size() > 0){
                for (Tv_Serie__c oldTVserie : oldTVseries) {
                    if(tvSerie.Name == oldTVserie.Name) {
                    tvSerie.AddError('This TV Series name already exist.'); 
                    }   
                }
            }                         
        }
    }
}