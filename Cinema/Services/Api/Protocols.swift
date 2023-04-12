//
//  Protocols.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

protocol IApiRepositoryAuthScreen {
    func signIn(user: LoginCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryProfileScreen {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(imageUrl: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

