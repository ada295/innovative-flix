public with sharing class EpisodeHandler {
    public static void checkUniqueEpisodeFieldsForTVSerie (List<Episode__c> episodes) {
        if (episodes == null) {
            return;
        }
        for (Episode__c episode : episodes) {
            List<Episode__c> seasonEpisodes = [SELECT Name, Order__c FROM Episode__c WHERE Season__c = :episode.Season__c];
            if(seasonEpisodes.size() > 0){
                for(Episode__c seasonEpisode : seasonEpisodes){
                    if(episode.Name == seasonEpisode.Name){
                        episode.AddError('The episode name already exists for the selected season.');
                    }
                    if(episode.Order__c == seasonEpisode.Order__c){
                        episode.AddError('The episode order already exists for selected season.');
                    }
                }
            }
        }
    }

    public static void updateEpisodeName (List<Episode__c> newEpisodes, List<Episode__c> oldEpisodes){
        if (newEpisodes == null){
            return;
        }
        List<Episode__c> updatedEpisodes = new List<Episode__c>();
        for (Integer i = 0; i < newEpisodes.size(); i++) {
            if (newEpisodes[i].Name != oldEpisodes[i].Name) {
                updatedEpisodes.add(newEpisodes[i]);
            }
        }
        EpisodeHandler.checkUniqueEpisodeFieldsForTVSerie(updatedEpisodes);
    }

    public static void updateEpisodeOrder(List<Episode__c> newEpisodes, List<Episode__c> oldEpisodes){
        if (newEpisodes == null) {
            return;
        }
        List<Episode__c> updatedEpisodes = new List<Episode__c>();
        for (Integer i = 0; i < newEpisodes.size(); i++) {
            if (newEpisodes[i].Order__c != oldEpisodes[i].Order__c) {
                updatedEpisodes.add(newEpisodes[i]);
            }
        }
        EpisodeHandler.checkUniqueEpisodeFieldsForTVSerie(updatedEpisodes);
    }

    public static void updateEpisodeValidation(List<Episode__c> newEpisodes, List<Episode__c> oldEpisodes){
        EpisodeHandler.updateEpisodeName(newEpisodes, oldEpisodes);
        EpisodeHandler.updateEpisodeOrder(newEpisodes, oldEpisodes);
    }
}