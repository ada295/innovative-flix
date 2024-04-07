trigger SeasonTrigger on Season__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate){
            SeasonHandler.checkUniqueSeasonFieldsByTVSerieId(Trigger.new);
        }
    }
}