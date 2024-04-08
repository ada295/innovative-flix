/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 08/04/2024
 * @description This class provides methods for handling Seasons.
 */
public with sharing class SeasonHandler {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 08/04/2024
     * @description The method handles logic before insertion or update of Season__c records.
     * 
     * @param seasons List of new Season__c records or Season__c records with updated data.
     * @param tvSerieSeasons List with data existing Season__c records in particular TV_serie__c.
     */
    public static void checkUniqueSeasonFieldsByTVSerieId (List<Season__c> seasons) {
        if(seasons == null){
            return;
        }

        for(Season__c season : seasons){
            List<Season__c> tvSerieSeasons = [SELECT Name, Order__c FROM Season__c
                WHERE TV_Serie__c = :season.TV_Serie__c AND Id <> :season.Id];
            
            if(tvSerieSeasons.size() > 0){
                for (Season__c tvSerieSeason : tvSerieSeasons) {
                    if(season.Name == tvSerieSeason.Name) {
                    season.AddError('This season name already exist for chosen TV Series.'); 
                    }   
                    if(season.Order__c == tvSerieSeason.Order__c){
                        season.AddError('This order already exist for chosen TV Series.');
                    }
                }
            }                         
        }
    }
}