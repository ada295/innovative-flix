public with sharing class CategoryHandler {
    public static void checkUniqueCategoryName (List<Category__c> categories) {
        if(categories == null){
            return;
        }

        for(Category__c category : categories){
            List<Category__c> oldCategories = [SELECT Name FROM Category__c
                WHERE Name = :category.Name AND Id <> :category.Id];
         
            if(oldCategories.size() > 0){
                for (Category__c oldCategory : oldCategories) {
                    if(category.Name == oldCategory.Name) {
                    category.AddError('This category name already exist.'); 
                    }   
                }
            }                         
        }
    }
}