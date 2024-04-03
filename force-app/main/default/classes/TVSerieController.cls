/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides method that gets TV Serie data.
 */
public with sharing class TVSerieController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of TV Series which have chosen Category.
     * 
     * @param categoryId Id of the chosen Category.
     */
    @AuraEnabled(cacheable=true)
    public static TV_Serie__c[] getAllTvSeriesByCategoryId(Id categoryId){
        try {
            return [
                SELECT Name, Description__c, Logo__c, Trailer__c
                FROM TV_Serie__c
                WHERE Id IN (
                    SELECT TV_Serie__c
                    FROM TV_Serie_Category__c
                    WHERE Category__c = :categoryId
                ) ORDER BY Name
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}