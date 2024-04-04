/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides method that gets Seasons data.
 */
public with sharing class SeasonController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of all Seasons of chosen TV Serie.
     * 
     * @param tvSerieId Id of the chosen TV Serie.
     */
    @AuraEnabled(cacheable=true)
    public static Season__c[] getAllSeasonsByTvSerieId(Id tvSerieId){
        try {
            return [
                SELECT Name
                FROM Season__c
                WHERE TV_Serie__c = :tvSerieId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}