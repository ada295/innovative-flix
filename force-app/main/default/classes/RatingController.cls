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
     * @param tvSerieId Id of the chosen seasonId.
     */
    @AuraEnabled(cacheable = false)
    public static Rating__c getLoggedUserRatingForSeason(Id seasonId) {
        String userId = UserInfo.getUserId();
        
        User[] user = [SELECT Id, Name, UserRoleId FROM User];
        for(User u: user) {
            System.debug('Name:' + u.Name + ' role:' + u.UserRoleId);
        }
        Rating__c[] res = [SELECT Id, Points__c FROM Rating__c WHERE RatingOwner__c = :userId AND Season__c = :seasonId LIMIT 1];
        if(res != null && res.size() > 0) {
            return res[0];
        }
        return null;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method handles logic before insertion or update of TV_Serie_Category__c records.
     * 
     * @param seasonId Id of the chosen Season__c.
     * @param points String with nymber of points.
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
}