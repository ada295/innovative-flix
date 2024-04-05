trigger EpisodeTrigger on Episode__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert) {
            EpisodeHandler.checkUniqueEpisodeFieldsForTVSerie(Trigger.new);
        } else if (Trigger.isUpdate) {
            EpisodeHandler.updateEpisodeValidation(Trigger.new, Trigger.old);
        }
    }
}