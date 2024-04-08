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
        return [
                SELECT Id, Name, Image__c
                FROM Category__c
                ORDER BY Name
            ];
    }
}