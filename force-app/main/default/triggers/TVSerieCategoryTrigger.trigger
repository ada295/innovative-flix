trigger TVSerieCategoryTrigger on TV_Serie_Category__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate) {
            TVSerieCategoryHandler.checkUniqueTVSerieCategory(Trigger.new);
        }
    }
}