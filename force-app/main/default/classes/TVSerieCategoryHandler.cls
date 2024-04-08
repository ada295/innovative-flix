public with sharing class TVSerieCategoryHandler {
    public static void checkUniqueTVSerieCategory (List<TV_Serie_Category__c> tvSeriesCategories) {
     if(tvSeriesCategories == null){
         return;
     }

     for(TV_Serie_Category__c tvSerieCategory : tvSeriesCategories){
         List<TV_Serie_Category__c> oldTVseriesCategories = [SELECT Category__c, TV_Serie__c FROM TV_Serie_Category__c
             WHERE Category__c = :tvSerieCategory.Category__c AND TV_Serie__c = :tvSerieCategory.TV_Serie__c 
             AND  Id <> :tvSerieCategory.Id];
         
         if(oldTVseriesCategories.size() > 0){
             for (TV_Serie_Category__c oldTVserieCategorie : oldTVseriesCategories) {
                 if(tvSerieCategory.Category__c == oldTVserieCategorie.Category__c && tvSerieCategory.TV_Serie__c == oldTVserieCategorie.TV_Serie__c) {
                 tvSerieCategory.AddError('This TV Series Category already exist.'); 
                 }   
             }
        }                         
     }
 }
}