/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 08/04/2024
 * @description This class provides methods for handling Categories.
 */
public with sharing class CategoryHandler {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 08/04/2024
     * @description The method handles logic before insertion or update of Category__c records.
     * 
     * @param categories List of new Category__c records or Category__c records with updated data.
     * @param oldCategories List with data existing Category__c records.
     */
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