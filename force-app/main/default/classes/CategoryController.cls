/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides method that gets Categories data.
 */
public with sharing class CategoryController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of all Categories.
     */
    @AuraEnabled(cacheable=true)
    public static Category__c[] getAllCategories() {
        // try {
        //     return [
        //         SELECT Name, Image__c
        //         FROM Category__c
        //         ORDER BY Name
        //     ];
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }



        // List<CategoryDTO> result = new List<CategoryDTO>();
        // Category__c[] categories = [SELECT Id, Name, Image__c FROM Category__c ORDER BY Name];
        // for(Category__c category: categories) {
        //     String imgStyle = 'background-image: linear-gradient(rgba(255, 255, 255, 0.863), rgba(248, 248, 248, 0.854)), url(' + category.Image__c + ');';
        //     CategoryDTO nCategory = new CategoryDTO(category.Id, category.Name, category.Image__c, imgStyle);
        //     nCategory.name = 'dsadsadsadsadsadsadsadsa';
        //     result.add(nCategory);
        // }

        return [
                SELECT Id, Name, Image__c
                FROM Category__c
                ORDER BY Name
            ];
    }
}
