public with sharing class TvResponseDTO {   
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public List<String> genres;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String premiered;
    @AuraEnabled
    public String ended;
    @AuraEnabled
    public ImageDTO image;
    @AuraEnabled
    public String summary;
    @AuraEnabled
    public EmbeddedDTO embedded;
}