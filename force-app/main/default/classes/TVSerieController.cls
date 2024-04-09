/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides methods for getting TV Series data and Batch for daily deleting TV Series with ezpired date .
 */
public with sharing class TVSerieController implements Database.Batchable<SObject>, Schedulable{
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of TV Series which have chosen Category.
     * 
     * @param categoryId Id of the chosen Category.
     */
    @AuraEnabled(cacheable=false)
    public static TV_Serie__c[] getAllTvSeriesByCategoryId(Id categoryId){
        try {
            return [
                SELECT Name, Logo__c
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

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns TV Serie's details by ID.
     * 
     * @param tvSerieId Id of TV_Serie__c.
     */
    @AuraEnabled(cacheable=false)
    public static TV_Serie__c getTvSerieDetails(String tvSerieId) {
        try {
            return [
                SELECT Name, Summary__c, Logo__c, Trailer__c, Rating__c
                FROM TV_Serie__c
                WHERE Id = :tvSerieId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

        /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/04/2024
     * @description The method returns TV Serie's with best ratings.
     * 
     * @param maxBestRated Number of TV_Serie__c records that the method will return.
     */
    @AuraEnabled(cacheable=false)
    public static Tv_Serie__c[] getBestRatingTvSeries(Integer maxBestRated) {
        try {
            return [
                SELECT Name, Summary__c, Logo__c, Trailer__c, Rating__c
                FROM TV_Serie__c WHERE Rating__c <> null
                ORDER BY Rating__c DESC LIMIT :maxBestRated
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/04/2024
     * @description The method returns latest added TV Serie's.
     * 
     * @param maxLatestAdded Number of TV_Serie__c records that the method will return.
     */
    @AuraEnabled(cacheable=false)
    public static Tv_Serie__c[] getLatestAddedTvSeries(Integer maxLatestAdded) {
        try {
            return [
                SELECT Name, Summary__c, Logo__c, Trailer__c, Rating__c
                FROM TV_Serie__c WHERE CreatedDate <> null
                ORDER BY CreatedDate DESC LIMIT :maxLatestAdded
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 04/04/2024
     * @description The method returns Id Of random TV Serie.
     */
    @AuraEnabled(cacheable=false)
    public static Id getRandomTvSerieDetails() {
        TV_Serie__c[] ids =   [
                SELECT Id
                FROM TV_Serie__c
                WHERE Only_for_adults__c <> true
            ];

        if(ids.size() > 0) {
            Integer randomNumber = Integer.valueOf(Math.floor(Math.random() * ids.size()));
            return ids[randomNumber].Id;
        }

        return null;
    }


    /**
    * @author Adrianna Zajac <adrianna.zajac@accenture.com>
    * @date 07/04/2024
    * @description This method is responsible for search TV Series to delete.
    *
    *@param deadline This is the date that determines the limits of TV series records to be deleted.
    */
    public Database.QueryLocator start (Database.BatchableContext bc) {
        Date deadline = Date.today();
        return Database.getQueryLocator('SELECT Id FROM TV_Serie__c WHERE Expired_date__c < :deadline OR Expired_date__c = :deadline');
    }
    /**
    * @author Adrianna Zajac <adrianna.zajac@accenture.com>
    * @date 07/04/2024
    * @description This method is responsible for deleting TV Series with Expired date (Today).
    * 
    *@param tvSeriesToDelete List of TV Series which will be deleted.
    */
    public void execute(Database.BatchableContext bc, List<Tv_Serie__c> tvSeriesToDelete) {
        delete tvSeriesToDelete;
    }

    public void finish(Database.BatchableContext bc) {
    }
    /**
    * @author Adrianna Zajac <adrianna.zajac@accenture.com>
    * @date 07/04/2024
    * @description This method is responsible for scheduling the next batch method call.
    */
    public void execute(SchedulableContext sc) {
        TVSerieController batch = new TVSerieController();
        System.debug('TV Series with expired date deleted successfully!');
        Database.executeBatch(batch);
    }
}