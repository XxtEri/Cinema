//
//  Protocols.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

protocol IApiRepositoryAuthScreen {
    func signIn(user: LoginCredential, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<Void, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryCompilationScreen {
    func getCompilationMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
//    func setDislikeMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryProfileScreen {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func editInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void)
}

