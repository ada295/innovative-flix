/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides method that gets Episodes data.
 */
public with sharing class EpisodeController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of all Episodes of chosen Season.
     * 
     * @param seasonId Id of the chosen Season.
     */
    @AuraEnabled(cacheable=true)
    public static Episode__c[] getAllEpisodesBySeasonId(Id seasonId){
        try {
            return [
                SELECT Name, Description__c
                FROM Episode__c
                WHERE Season__c = :seasonId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}