public with sharing class RatingController {
   
    @AuraEnabled(cacheable = false)
    public static Rating__c getLoggedUserRatingForSeason(Id seasonId) {
        String userId = UserInfo.getUserId();
        Rating__c[] res = [SELECT Id, Points__c FROM Rating__c WHERE RatingOwner__c = :userId AND Season__c = :seasonId LIMIT 1];
        if(res != null && res.size() > 0) {
            return res[0];
        }
        return null;
    }

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