//
//  Protocols.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

protocol IApiRepositoryAuthScreen {
    func signIn(user: LoginCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryCollectionScreen {
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void)
    func addNewCollection(completion: @escaping (Result<Collection, Error>) -> Void)
    func deleteCollection(collectionId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getMoviesInCollection(collectionId: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func addMoviesInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteMovieInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryProfileScreen {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void)
}

