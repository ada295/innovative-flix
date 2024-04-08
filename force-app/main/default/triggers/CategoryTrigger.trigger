trigger CategoryTrigger on Category__c (before insert, before update) {
    if(Trigger.isBefore){
        if (Trigger.isInsert || Trigger.isUpdate) {
            CategoryHandler.checkUniqueCategoryName(Trigger.new);
        }
    }
}