trigger EpisodeTrigger on Episode__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate) {
            System.debug('trigger working');
            EpisodeHandler.checkUniqueEpisodeFieldsBySeasonId(Trigger.new);
        }
    }
}