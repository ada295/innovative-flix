public with sharing class TVSeriesHandler {
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