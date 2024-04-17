/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 29/03/2024
 * @description This class provides method that gets Episodes data.
 */
public with sharing class EpisodeController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 29/03/2024
     * @description The method returns list of all Episodes of chosen Season and actual page.
     * 
     * @param seasonId Id of the chosen Season.
     * @param page Number of actual page.
     */
    @AuraEnabled(cacheable=false)
    public static EpisodesResponseDTO getAllEpisodesBySeasonId(Id seasonId, Integer page) {
        if(page == null) {
            page = 1;
        }
        EpisodesResponseDTO response = new EpisodesResponseDTO();
        decimal pageSize1 = 10;
        Integer pageSize = 10;
        Integer offset = (page - 1) * pageSize;
        
        try {
            Integer all = [   
                SELECT COUNT()
                FROM Episode__c
                WHERE Season__c = :seasonId
            ];


            response.episodes = [
                SELECT Name, Summary__c
                FROM Episode__c
                WHERE Season__c = :seasonId
                ORDER BY Order__c
                LIMIT :pageSize OFFSET :offset
            ];

            response.page = page;
            response.allFound = all;
            response.allPages = (all / pageSize1).round(System.RoundingMode.UP).intValue();

            System.debug(response);

            return response;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}