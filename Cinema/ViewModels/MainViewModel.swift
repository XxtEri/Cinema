//
//  MainScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

class MainViewModel {
    private let api: ApiRepository
    private let service: CollectionService
    weak var navigation: MainScreenNavigation?
    
    var coverMovie = Observable<CoverMovie>()
    var trendsMovie = Observable<[Movie]>()
    var lastWatchEpisodes = Observable<[EpisodeView]>()
    var newMovie = Observable<[Movie]>()
    var recomendationMovie = Observable<[Movie]>()
    var episodesMovie = Observable<[Episode]>()
    var currentEpisodeTime = Observable<EpisodeTime>()
    var errorOnLoading = Observable<Error>()

    var lastWatchMovies = [Movie]()
    var episodeLastWatchMovie = [Episode]()
    
    var goToAuthScreen = false
    
    init(navigation: MainScreenNavigation) {
        self.navigation = navigation
        self.service = CollectionService()
        self.api = ApiRepository()
    }
    
    func goToMovieScreen(movie: Movie) {
        navigation?.goToMovieScreen(movie: movie)
    }
    
    func goToEpisodeScreen(movie: Movie, episode: Episode, episodes: [Episode]) {
        navigation?.goToEpisodeScreen(movie: movie, currentEpisode: episode, episodes: episodes)
    }
    
    func goToEpisodeScreenLastWatchMovie(currentEpisode: EpisodeView) {
        self.api.getLastWatchMovies { result in
            switch result {
            case .success(let movies):
                movies.forEach { movie in
                    if movie.movieId == currentEpisode.movieId {
                        self.api.getEpisodesMovie(movieId: currentEpisode.movieId) { result in
                            switch result {
                            case .success(let episodes):
                                episodes.forEach { episode in
                                    if episode.episodeId == currentEpisode.episodeId {
                                        self.navigation?.goToEpisodeScreen(movie: movie, currentEpisode: episode, episodes: episodes)
                                    }
                                }
                            case .failure(let error):
                                if self.api.requestStatus == .notAuthorized {
                                    self.service.clearDatabase()
                                    self.navigation?.goToAuthorizationScreen()
                                } else {
                                    self.failureLoadingHandle(with: error)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func backToGoLastScreen() {
        navigation?.backToGoLastScreen()
    }
}

private extension MainViewModel {
    func successLoadingHandle(with coverImageMovie: CoverMovie) {
        self.coverMovie.updateModel(with: coverImageMovie)
    }
    
    func successLoadingHandle(with movies: [Movie], typeListMovie: TypeListMovieMainScreen) {
        switch typeListMovie {
        case .trend:
            self.trendsMovie.updateModel(with: movies)
        case .new:
            self.newMovie.updateModel(with: movies)
        case .recomendation:
            self.recomendationMovie.updateModel(with: movies)
        case .lastView:
            self.lastWatchMovies = movies
        }
    }
    
    func successLoadingHandle(with movies: [EpisodeView]) {
        self.lastWatchEpisodes.updateModel(with: movies)
    }
    
    func successLoadingHandle(with episodes: [Episode]) {
        self.episodesMovie.updateModel(with: episodes)
    }
    
    func successLoadingHandle(with time: EpisodeTime) {
        self.currentEpisodeTime.updateModel(with: time)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension MainViewModel: IMainViewModel {
    func getCoverImage() {
        self.api.getCoverFilm { result in
            switch result {
            case .success(let coverImageMovie):
                self.successLoadingHandle(with: coverImageMovie)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.goToAuthScreen = true
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func getMoviesForMainScreen() {
        self.api.getMovies(typeListMovie: .trend) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .trend)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.goToAuthScreen = true
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
        
        self.api.getHistoryMovie { result in
            switch result {
            case .success(let movie):
                self.successLoadingHandle(with: movie)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.goToAuthScreen = true
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
        
        self.api.getMovies(typeListMovie: .new) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .new)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.goToAuthScreen = true
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
        
        self.api.getMovies(typeListMovie: .recomendation) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .recomendation)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.goToAuthScreen = true
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func getLastWatchMovies() {
        self.api.getLastWatchMovies { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .lastView)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized && !self.goToAuthScreen {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func getEpisodesMovie(movieId: String) {
        self.api.getEpisodesMovie(movieId: movieId) { result in
            switch result {
            case .success(let episodes):
                self.successLoadingHandle(with: episodes)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func getEpisodesLastWatchMovie(movieId: String) {
        self.api.getEpisodesMovie(movieId: movieId) { result in
            switch result {
            case .success(let episodes):
                self.episodeLastWatchMovie = episodes
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func getEpisodeTime(episodeId: String) {
        self.api.getCurrentEpisodeTime(episodeId: episodeId) { [ self ] result in
            switch result {
            case .success(let time):
                successLoadingHandle(with: time)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func saveEpisodeTime(episodeId: String, time: EpisodeTime) {
        self.api.saveCurrentEpisodeTime(episodeId: episodeId, time: time) { [ self ] result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized {
                    self.navigation?.goToAuthorizationScreen()
                } else {
                    if self.api.requestStatus == .notAuthorized {
                        self.service.clearDatabase()
                        self.navigation?.goToAuthorizationScreen()
                    } else {
                        self.failureLoadingHandle(with: error)
                    }
                }
            }
        }
    }
}
