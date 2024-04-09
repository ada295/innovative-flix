trigger TVSerieTrigger on Tv_Serie__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate) {
            TVSeriesHandler.checkUniqueTVSeriesName(Trigger.new);
        }
    }
}