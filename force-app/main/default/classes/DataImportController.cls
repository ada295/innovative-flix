public with sharing class DataImportController {
 
    public DataImportController() {
 
    }

    public static void importTvSerie() {
        String tvSerieName = 'The%20Bold%20and%20the%20Beautiful';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/singlesearch/shows?q='+tvSerieName);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {
             processTVSerie(res);
        }
    }

    private static void processTvSerie(HttpResponse res) {
            String responseBody = res.getBody();       
            TvResponseDTO response = (TvResponseDTO)JSON.deserialize(responseBody, TvResponseDTO.class);
            HttpResponse seasonsRes = fetchSeasons(response.id);
            IdHolder[] seasonsIds = ((IdHolder[])JSON.deserialize(seasonsRes.getBody(), IdHolder[].class));
            List<HttpResponse> episodeResponses = new List<HttpResponse>();
            for(IdHolder idHolder: seasonsIds) {
                episodeResponses.add(fetchEpisodes(idHolder.id));
            }
            Tv_Serie__c tvSerie =  processTVSeriesData(response);
            processEpisodesData(tvSerie, episodeResponses);
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
        tvSerie.Summary__c = response.summary;
        // result.setName(response.genres);
    }

    private static HttpResponse fetchSeasons(String showId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.tvmaze.com/shows/'+showId+'/seasons');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('Fetched seasons.');
        return res;
    }

    private static HttpResponse fetchEpisodes(String seasonId) {
        HttpRequest episodesReq = new HttpRequest();
        episodesReq.setEndpoint('https://api.tvmaze.com/seasons/'+seasonId+'/episodes');
        episodesReq.setMethod('GET');
        Http http = new Http();
        HttpResponse episodesRes = http.send(episodesReq);

        System.debug('Fetched episodes.');
        return episodesRes;
    }

    private static void processEpisodesData(Tv_Serie__c tvSerie, List<HttpResponse> responses) {
        for(HttpResponse res: responses) {
           processEpisodesData(tvSerie, res);
        }
    }

    private static void processEpisodesData(Tv_Serie__c tvSerie, HttpResponse res) {
                EpisodeDTO[] episodeDTOs = ((EpisodeDTO[])JSON.deserialize(res.getBody(), EpisodeDTO[].class));
                Map<String, Season__c> seasonsByName = new Map<String, Season__c>(); //season name is key
                Map<String, List<Episode__c>> episodesBySeasonName = new Map<String, List<Episode__c>>(); //season name is key

                String lastProcessedSeason = '';
                Integer episodeNumberCounter = 0;
                for (EpisodeDTO episodeDTO : episodeDTOs) {
                    Episode__c episode = new Episode__c();

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
                    insert episodes;
                }   

    }

}