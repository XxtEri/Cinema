//
//  MainScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

class MainViewModel {
    private let api: IApiRepositoryMain
    weak var navigation: MainScreenNavigation?
    
    var coverMovie = Observable<CoverMovie>()
    
    var trendsMovie = Observable<[Movie]>()
    
    var lastWatchMovies = Observable<[EpisodeView]>()
    
    var newMovie = Observable<[Movie]>()
    
    var recomendationMovie = Observable<[Movie]>()
    
    var episodesMovie = Observable<[Episode]>()
    
    var errorOnLoading = Observable<Error>()
    
    init(navigation: MainScreenNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToMovieScreen(movie: Movie) {
        navigation?.goToMovieScreen(movie: movie)
    }
    
    func goToEpisodeScreen(movie: Movie, episode: Episode) {
        navigation?.goToEpisodeScreen(movie: movie, episode: episode)
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
        }
    }
    
    func successLoadingHandle(with movies: [EpisodeView]) {
        self.lastWatchMovies.updateModel(with: movies)
    }
    
    func successLoadingHandle(with episodes: [Episode]) {
        self.episodesMovie.updateModel(with: episodes)
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
                self.failureLoadingHandle(with: error)
            }
        }
    }
    
    func getMovies() {
        self.api.getMovies(typeListMovie: .trend) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .trend)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getHistoryMovie { result in
            switch result {
            case .success(let movie):
                self.successLoadingHandle(with: movie)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getMovies(typeListMovie: .new) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .new)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getMovies(typeListMovie: .recomendation) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .recomendation)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
    
    func getEpisodesMovie(movieId: String) {
        self.api.getEpisodesMovie(movieId: movieId) { result in
            switch result {
            case .success(let episodes):
                self.successLoadingHandle(with: episodes)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}
