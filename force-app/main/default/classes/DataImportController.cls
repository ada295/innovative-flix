public with sharing class DataImportController {
 
    public DataImportController() {
 
    }

    public static void importTvSerie() {
        String tvSerieName = 'Monk';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/singlesearch/shows?q='+tvSerieName+'&embed=episodes');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            responseBody = responseBody.replaceAll('"_embedded"', '"embedded"'); //apex does not allow @JsonProperty('')
            responseBody = responseBody.replaceAll('"number"', '"episodeNumber"'); //apex does not allow @JsonProperty(''), number is reserved?!
            
            TvResponseDTO response = (TvResponseDTO)JSON.deserialize(responseBody, TvResponseDTO.class);
            Tv_Serie__c tvSerie =  processTVSeriesData(response);
            processEpisodesData(response, tvSerie);
        } else {
            System.debug('Błąd API: ' + res.getStatus());
        }
    }

    private static Tv_Serie__c processTVSeriesData(TvResponseDTO response) {
        Tv_Serie__c result = new Tv_Serie__c();
        mapToTVSerie(response, result);
        System.debug('Inserting tv series' + result.Name);
        insert result;
        return result;
    }

    private static void mapToTVSerie(TvResponseDTO response, Tv_Serie__c tvSerie) {
        tvSerie.name = response.name;
        tvSerie.Logo__c = response.image.medium;
        // result.setStartDate(response.premiered);
        // result.setStatus(response.status);
        tvSerie.Description__c = response.summary;
        // result.setName(response.genres);
    }

    private static void processEpisodesData(TvResponseDTO response, Tv_Serie__c tvSerie) {
        try {
       List<EpisodeDTO> episodeDTOs = response.embedded.episodes;
       Map<String, Season__c> seasonsByName = new Map<String, Season__c>(); //season name is key
       Map<String, List<Episode__c>> episodesBySeasonName = new Map<String, List<Episode__c>>(); //season name is key
       for (EpisodeDTO episodeDTO : episodeDTOs) {
            Episode__c episode = new Episode__c();

            String seasonName = 'Season ' + episodeDTO.season;
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
            episode.Description__c = episodeDTO.summary;
            episode.Order__c = episodeDTO.episodeNumber;
            episodesBySeasonName.get(seasonName).add(episode);
       }

       insert seasonsByName.values();
       for (String seasonName : seasonsByName.keySet()) {
           List<Episode__c> episodes = episodesBySeasonName.get(seasonName);
           for (Episode__c episode : episodes) {
                episode.Season__c = seasonsByName.get(seasonName).Id;
           }
           insert episodes;
       }

    } catch(Exception e) {
        System.debug('Failed to auto import episodes.');
    }
    }

}