/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 07/04/2024
 * @description This class provides methods that gets Rating__c data.
 */
public with sharing class RatingController {
   /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method returns Rating__c of chosen seasonId.
     * 
     * @param seasonId Id of the chosen seasonId.
     */
    @AuraEnabled(cacheable = false)
    public static Rating__c getLoggedUserRatingForSeason(Id seasonId) {
        String userId = UserInfo.getUserId();
        
        // User[] user = [SELECT Id, Name, UserRoleId FROM User];
        // for(User u: user) {
        //     System.debug('Name:' + u.Name + ' role:' + u.UserRoleId);
        // }
        Rating__c[] res = [SELECT Id, Points__c FROM Rating__c WHERE RatingOwner__c = :userId AND Season__c = :seasonId LIMIT 1];
        if(res != null && res.size() > 0) {
            return res[0];
        }
        return null;
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 17/04/2024
     * @description The method returns Season rating of chosen seasonId.
     * 
     * @param tvSerieId Id of the chosen seasonId.
     */
    @AuraEnabled(cacheable = false)
    public static Season__c getRatingForSeason(Id seasonId) {
       
        Season__c season = [SELECT Id, Rating__c FROM Season__c WHERE Id = :seasonId];
        if(season != null) {
            return season;
        }
        return null;
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 17/04/2024
     * @description The method returns TVSerie rating of chosen seasonId.
     * 
     * @param tvSerieId Id of the chosen seasonId.
     */
    @AuraEnabled(cacheable = false)
    public static Tv_Serie__c getRatingForTVSerie(Id seasonId) {
       
        Season__c season = [SELECT Id, Tv_Serie__c FROM Season__c WHERE Id = :seasonId];
        Id tvSerieId = season.Tv_Serie__c;
        Tv_Serie__c tvSerie = [SELECT Id, Rating__c FROM Tv_Serie__c WHERE Id = :tvSerieId];
        if(tvSerie != null) {
            return tvSerie;
        }
        return null;
    }


    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before insertion or update of Rating__c records.
     * 
     * @param seasonId Id of the chosen Season__c.
     * @param points String with number of points.
     */
    @AuraEnabled(cacheable=false)
    public static void setLoggedUserRatingForSeason(Id seasonId, String points) {
        Rating__c rating = getLoggedUserRatingForSeason(seasonId);
        if(rating == null) {
            String userId = UserInfo.getUserId();
            rating = new Rating__c();
            rating.RatingOwner__c = userId;
            rating.Season__c = seasonId;
            rating.Points__c = points;
            insert rating;
        } else {
            rating.Points__c = points;
            update rating;
        }
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 17/04/2024
     * @description The method handles logic after insertion or update of Rating__c records and update Season and TV_Serie rating.
     * 
     * @param newRating The Raing__c which was just inserted or updated
     */
    @AuraEnabled(cacheable=false)
    public static void setSeasonsRatingsAndTVSeriesRatings(Rating__c newRating) {
        //season update rating
        List<Season__c> seasonsToUpdate = new List<Season__c>();

        Id seasonId = newRating.Season__c;

        Rating__c[] points = [SELECT Id, Points__c FROM Rating__c WHERE Season__c = :seasonId]; //salesforce does not support casting and AVG in one query...
        System.debug('ratings=' + points);
        Double sum = 0;
        for(Rating__c p: points){
            sum += Integer.valueOf(p.Points__c);
        }
        if(points.size() > 0) {
            System.debug('Sum=' + sum);
            Season__c season = [SELECT Id, Tv_Serie__c FROM Season__c WHERE Id = :seasonId];
            System.debug('Size=' + points.size());
            season.Rating__c = sum / points.size();
            System.debug('Salesforce AVG=' + (sum / points.size()));
            update season;
        

        //update TVSeries rating
        Id tvSerieId = season.Tv_Serie__c;

        //salesforce does not support joins
        // Rating[] ratings = [SELECT Id, Points__c FROM Rating__c r INNER JOIN Season_c s ON r.Season__c = s.Id INNER JOIN Tv_Serie__c t ON t.Id = s.Tv_Serie__c];
       
        //to calculate ratings for whole tvSerie we have to get ALL seasons related to the serie and all rating related to those seasons
            
        Season__c[] allSeasonsAffected = [SELECT Id FROM Season__c WHERE Tv_Serie__c = :tvSerieId];
        List<Id> allSeasonsAffectedIds = new List<Id>();
        for(Season__c seasonAffected: allSeasonsAffected) {
            allSeasonsAffectedIds.add(seasonAffected.Id);
        } 

        Rating__c[] pointsTVSerie = [SELECT Id, Points__c FROM Rating__c WHERE Season__c IN :allSeasonsAffectedIds];
        Double sumTVSeriePoints = 0;
        for(Rating__c p: pointsTVSerie){
            sumTVSeriePoints += Integer.valueOf(p.Points__c);
        }

        if(pointsTVSerie.size() > 0) {
            Tv_Serie__c tvSerie = [SELECT Id FROM Tv_Serie__c WHERE Id = :tvSerieId];
            System.debug('Sum=' + sum);
            System.debug('Size=' + points.size());
            tvSerie.Rating__c = sum / points.size();
            System.debug('Salesforce AVG=' + (sum / points.size()));

            update tvSerie; //it can be done without list beacuse 1 will be saved
        }
        }
    }
}