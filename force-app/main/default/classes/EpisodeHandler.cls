public with sharing class EpisodeHandler {
    public static void checkUniqueEpisodeFieldsBySeasonId (List<Episode__c> episodes) {
     if(episodes == null){
         return;
     }

     for(Episode__c episode : episodes){
        if(episode.Source__c != 'DataImport') {
            List<Episode__c> seasonEpisodes = [SELECT Name, Order__c FROM Episode__c
            WHERE Season__c = :episode.Season__c AND Id <> :episode.Id];
        
            if(seasonEpisodes.size() > 0) {
                for (Episode__c seasonEpisode : seasonEpisodes) {
                    if(episode.Name == seasonEpisode.Name) {
                    episode.AddError('This episode name already exist for chosen Season.'); 
                    }   
                    if(episode.Order__c == seasonEpisode.Order__c){
                        episode.AddError('This order already exist for chosen Season.');
                    }
                }
            }   
        }
                              
     }
 }
}