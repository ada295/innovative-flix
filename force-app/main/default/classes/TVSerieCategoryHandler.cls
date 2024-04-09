/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 08/04/2024
 * @description This class provides methods for handling TVSeriesCategories.
 */
public with sharing class TVSerieCategoryHandler {
     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 08/04/2024
     * @description The method handles logic before insertion or update of TV_Serie_Category__c records.
     * 
     * @param tvSeriesCategories List of new TV_Serie_Category__c records or TV_Serie_Category__c records with updated data.
     * @param oldTVseriesCategories List with data existing TV_Serie_Category__c records.
     */
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