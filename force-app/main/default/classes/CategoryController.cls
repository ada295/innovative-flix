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



        return [SELECT Name FROM Category__c ORDER BY Name];
    }
}
