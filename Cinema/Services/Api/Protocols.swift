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
    func getLastWatchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func getEpisodesMovie(movieId: String, completion: @escaping (Result<[Episode], Error>) -> Void)
    func getCurrentEpisodeTime(episodeId: String, completion: @escaping (Result<EpisodeTime, Error>) -> Void)
    func saveCurrentEpisodeTime(episodeId: String, time: EpisodeTime, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryCollectionScreen {
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void)
    func addNewCollection(collection: CollectionForm, completion: @escaping (Result<Collection, Error>) -> Void)
    func deleteCollection(collectionId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getMovieInCollection(collectionId: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}

protocol IApiRepositoryProfile {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(imageUrl: URL, completion: @escaping (Result<Void, Error>) -> Void)
}
protocol IApiRepositoryCompilationScreen {
    func getCompilationMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func setDislikeMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func addMovieToColletion(collectionId: String, movieValue: MovieValue, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteMovieInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryChatScreen {
    func getChatList(completion: @escaping (Result<[Chat], Error>) -> Void)
    func connectToChat(chatId: String, completion: @escaping (Result<MessageServer, Error>) -> Void)
    func sendMessage(chatId: String, message: String, completion: @escaping (Result<Void, Error>) -> Void)
    func disconnectChat()
    func getUserId(completion: @escaping (Result<String, Error>) -> Void)
}
