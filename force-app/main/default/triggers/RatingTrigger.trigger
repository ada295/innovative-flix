trigger RatingTrigger on Rating__c (after insert, after update) {
    if(Trigger.isAfter){
        if (Trigger.isInsert || Trigger.isUpdate) {
            //seasons update rating
            List<Rating__c> newRatings = Trigger.new;
            Set<Id> seasonsIdToUpdate = new Set<Id>();
            List<Season__c> seasonsToUpdate = new List<Season__c>();
            for(Rating__c newRating : newRatings){
                seasonsIdToUpdate.add(newRating.Season__c);
            }

            for (Id seasonId : seasonsIdToUpdate) {
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

                    seasonsToUpdate.add(season);
                }
            }
            update seasonsToUpdate;

            Set<Id> relatedTvSeries = new Set<Id>();
            for(Season__c season: seasonsToUpdate){
                relatedTvSeries.add(season.Tv_Serie__c);
            }

            //salesforce does not support joins
            // Rating[] ratings = [SELECT Id, Points__c FROM Rating__c r INNER JOIN Season_c s ON r.Season__c = s.Id INNER JOIN Tv_Serie__c t ON t.Id = s.Tv_Serie__c];
       
            //to calculate ratings for whole tvSerie we have to get ALL seasons related to the serie and all rating related to those seasons
            
            for(Id relatedTvSerie: relatedTvSeries) {
                Season__c[] allSeasonsAffected = [SELECT Id FROM Season__c WHERE Tv_Serie__c = :relatedTvSerie];
                List<Id> allSeasonsAffectedIds = new List<Id>();
                for(Season__c season: allSeasonsAffected) {
                    allSeasonsAffectedIds.add(season.Id);
                } 

                Rating__c[] points = [SELECT Id, Points__c FROM Rating__c WHERE Season__c IN :allSeasonsAffectedIds];
                Double sum = 0;
                for(Rating__c p: points){
                    sum += Integer.valueOf(p.Points__c);
                }

                if(points.size() > 0) {
                    Tv_Serie__c tvSerie = [SELECT Id FROM Tv_Serie__c WHERE Id = :relatedTvSerie];
                    System.debug('Sum=' + sum);
                    System.debug('Size=' + points.size());
                    tvSerie.Rating__c = sum / points.size();
                    System.debug('Salesforce AVG=' + (sum / points.size()));

                    update tvSerie; //it can be done without list beacuse 1 will be saved
                }
            }
        }
    }
}