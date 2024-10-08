/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 06/04/2024
 * @description This class provides methods for handling DataImport.
 */
public with sharing class DataImportController {
 
    public static Boolean executeTriggers = true;

    public DataImportController() {}

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method returns TvResponseDTO of chosen tvSerieName.
     * 
     * @param tvSerieName Written name of TV Serie Name.
     */
    @AuraEnabled
    public static List<TvResponseDTO> search(String tvSerieName) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/search/shows?q='+tvSerieName);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {
            String responseBody = res.getBody();       
            TvSerieSearchDTO[] searchResult  = (TvSerieSearchDTO[])JSON.deserialize(responseBody, TvSerieSearchDTO[].class);
            List<TvResponseDTO> result = new List<TvResponseDTO>();
            for(TvSerieSearchDTO s: searchResult) {
                result.add(s.show);
            }
            return result;
        }
        return null;
    }

      /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method import TV Serie by chosen TV Serie Id (id from tvmaze).
     * 
     * @param id Id of chosen TV Serie to import.
     */
    @AuraEnabled
    public static void importTvSerieById(String id) {
        System.debug('importing' + id);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/shows/'+ id);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        TvResponseDTO response = (TvResponseDTO)JSON.deserialize(res.getBody(), TvResponseDTO.class);
        HttpResponse seasonsRes = fetchSeasons(response.id);
            IdHolder[] seasonsIds = ((IdHolder[])JSON.deserialize(seasonsRes.getBody(), IdHolder[].class));
            List<HttpResponse> episodeResponses = new List<HttpResponse>();
            for(IdHolder idHolder: seasonsIds) {
                episodeResponses.add(fetchEpisodes(idHolder.id));
            }
            Tv_Serie__c tvSerie =  processTVSeriesData(response);
            processEpisodesData(tvSerie, episodeResponses);
    }

    
      /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method processes imported TV Serie data.
     * 
     * @param response Response form https://api.tvmaze.com/shows.
     */
    private static Tv_Serie__c processTVSeriesData(TvResponseDTO response) {
        Tv_Serie__c result = new Tv_Serie__c();
        mapToTVSerie(response, result);
        System.debug('Inserting tv series' + result.Name);
        insert result;
        return result;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method map processed data to TV_serie__c.
     * 
     * @param response Response from https://api.tvmaze.com/shows.
     * @param tvSerie New TV Serie.
    */
    private static void mapToTVSerie(TvResponseDTO response, Tv_Serie__c tvSerie) {
        tvSerie.name = response.name;
        tvSerie.Logo__c = response.image.medium;
        tvSerie.Summary__c = response.summary;
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method imports seasons by TV Serie Id (from tvmaze).
     * 
     * @param showId Id of TV Serie in tvmaze.
    */
    private static HttpResponse fetchSeasons(String showId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/shows/'+showId+'/seasons');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('Fetched seasons.');
        return res;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method imports seasons by season Id (from tvmaze).
     * 
     * @param seasonId Id of season in tvmaze.
    */
    private static HttpResponse fetchEpisodes(String seasonId) {
        HttpRequest episodesReq = new HttpRequest();
        episodesReq.setEndpoint('https://api.tvmaze.com/seasons/'+seasonId+'/episodes');
        episodesReq.setMethod('GET');
        Http http = new Http();
        HttpResponse episodesRes = http.send(episodesReq);

        System.debug('Fetched episodes.');
        return episodesRes;
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method processes episodes data from tvmaze.
     * 
     * @param tvSerie New imported TV Serie.
     * @param responses Responses from tvmaze.
    */
    private static void processEpisodesData(Tv_Serie__c tvSerie, List<HttpResponse> responses) {
        for(HttpResponse res: responses) {
            processEpisodesData(tvSerie, res);
        }
    }

         /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 07/04/2024
     * @description The method processes episodes data from tvmaze.
     * 
     * @param tvSerie New imported TV serie.
     * @param responses Responses from tvmaze.
    */
    private static void processEpisodesData(Tv_Serie__c tvSerie, HttpResponse res) {
        EpisodeDTO[] episodeDTOs = ((EpisodeDTO[])JSON.deserialize(res.getBody(), EpisodeDTO[].class));
        Map<String, Season__c> seasonsByName = new Map<String, Season__c>(); //season name is key
        Map<String, List<Episode__c>> episodesBySeasonName = new Map<String, List<Episode__c>>(); //season name is key

        String lastProcessedSeason = '';
        Integer episodeNumberCounter = 0;
        for (EpisodeDTO episodeDTO : episodeDTOs) {
            Episode__c episode = new Episode__c();
            episode.Source__c = 'DataImport';

            String seasonName = 'Season ' + episodeDTO.season;

            if(seasonName.equals(lastProcessedSeason)) {
                episodeNumberCounter++;
            } else {
                episodeNumberCounter = 1;
                lastProcessedSeason = seasonName;
            }

            if(!seasonsByName.containsKey(seasonName)) {
                Season__c season = new Season__c();
                season.Name = seasonName;
                season.Order__c = episodeDTO.season;
                season.TV_Serie__c = tvSerie.Id;
                seasonsByName.put(seasonName, season);
            }

            if(!episodesBySeasonName.containsKey(seasonName)) { //first time episode is added to the map
                episodesBySeasonName.put(seasonName, new List<Episode__c>());
            }
                
            episode.Name = episodeDTO.name;
            episode.Summary__c = episodeDTO.summary;
            episode.Order__c = episodeNumberCounter;
            episodesBySeasonName.get(seasonName).add(episode);
        }

        insert seasonsByName.values();
        for (String seasonName : seasonsByName.keySet()) {
            List<Episode__c> episodes = episodesBySeasonName.get(seasonName);
            for (Episode__c episode : episodes) {
                episode.Season__c = seasonsByName.get(seasonName).Id;
            }
            executeTriggers = false;
            insert episodes;
            executeTriggers = true;
        }   
    }
}