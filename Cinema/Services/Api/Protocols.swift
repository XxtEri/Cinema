//
//  Protocols.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

protocol IApiRepositoryAuth {
    func signIn(user: LoginCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryMain {
    func getCoverFilm(completion: @escaping (Result<CoverMovie, Error>) -> Void)
    func getMovies(typeListMovie: TypeListMovieMainScreen, completion: @escaping (Result<[Movie], Error>) -> Void)
    func getHistoryMovie(completion: @escaping (Result<[EpisodeView], Error>) -> Void)
    func getEpisodesMovie(movieId: String, completion: @escaping (Result<[Episode], Error>) -> Void)
    func getCurrentEpisodeTime(episodeId: String, completion: @escaping (Result<EpisodeTime, Error>) -> Void)
    func saveCurrentEpisodeTime(episodeId: String, time: EpisodeTime, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryCollectionScreen {
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void)
    func addNewCollection(collection: CollectionForm, completion: @escaping (Result<Collection, Error>) -> Void)
    func deleteCollection(collectionId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getMoviesInCollection(collectionId: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func addMoviesInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteMovieInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryProfile {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(imageUrl: URL, completion: @escaping (Result<Void, Error>) -> Void)
}
protocol IApiRepositoryCompilationScreen {
    func getCompilationMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func setLikeMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
//    func setDislikeMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
