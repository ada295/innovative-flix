trigger EpisodeTrigger on Episode__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate) {
            EpisodeHandler.checkUniqueEpisodeFieldsBySeasonId(Trigger.new);
        }
    }
}