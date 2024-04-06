public with sharing class EpisodesResponseDTO {
    @AuraEnabled
    public Episode__c[] episodes;
    @AuraEnabled
    public Integer page;
    @AuraEnabled
    public Integer allFound;
    @AuraEnabled
    public Integer allPages;
}