//
//  ApiRepository.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation
import Alamofire
import KeychainSwift

class ApiRepository {
    
    private let session: Alamofire.Session
    
    private let keychain: KeychainSwift
    
    private let baseURL = "http://107684.web.hosting-russia.ru:8000/api"
    
    var requestStatus: RequestStatus = .notSend
    
    init() {
        self.session = .default
        self.keychain = KeychainSwift()
    }
}

extension ApiRepository: IApiRepositoryAuth {
    func signIn(user: LoginCredential, completion: @escaping (Result<Void, Error>) -> Void) {
        
        self.session.request(
            "\(baseURL)/auth/login",
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.default
        ).responseDecodable(of: AuthTokenPair.self) { [self] response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(String(describing: statusCode))")
            }
            
            guard let token = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            self.keychain.synchronizable = true
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            
            print(token)
            
            completion(.success(()))
        }
    }
    
    func signUp(user: RegisterCredential, completion: @escaping (Result<Void, Error>) -> Void) {
        
        self.session.request(
            "\(baseURL)/auth/register",
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.default
        ).responseDecodable(of: AuthTokenPair.self) { response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(String(describing: statusCode))")
            }
            
            guard let token = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            self.keychain.synchronizable = true
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            
            print(token)
            
            completion(.success(()))
        }
    }
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        if let token = self.keychain.get("refreshToken") {
            headers["Authorization"] = "Bearer" + token
        }
        
        
        self.session.request(
            "\(baseURL)/auth/refresh",
            method: .post,
            headers: headers
        ).responseDecodable(of: AuthTokenPair.self) { [self] response in
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
            }
            
            guard let token = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            self.keychain.synchronizable = true
            self.keychain.clear()
            
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            
            print(token)
            
            completion(.success(()))
        }
    }
}

extension ApiRepository: IApiRepositoryProfile {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/profile",
            method: .get,
            headers: headers
        ).responseDecodable(of: User.self) { response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getInformationProfile(completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            guard let user = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func editInformationProfile(completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void) {
        
    }
}

extension ApiRepository: IApiRepositoryMain {
    func getCoverFilm(completion: @escaping (Result<CoverMovie, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        session.request(
            "\(baseURL)/cover",
            method: .get,
            headers: headers
        ).responseDecodable(of: CoverMovie.self) { response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getCoverFilm(completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            guard let coverMovie = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(coverMovie))
        }
    }
    
    func getMovies(typeListMovie: TypeListMovieMainScreen, completion: @escaping (Result<[Movie], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        let parameters: Parameters = [
            "filter" : typeListMovie.rawValue
        ]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/movies",
            method: .get,
            parameters: parameters,
            headers: headers
        ).responseDecodable(of: [Movie].self) { response in
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getMovies(typeListMovie: typeListMovie, completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            
                            self.keychain.synchronizable = true
                            self.keychain.clear()
                            
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
                
            }
            
            
            guard let movies = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(movies))
        }
    }
    
    func getHistoryMovie(completion: @escaping (Result<[EpisodeView], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/history",
            method: .get,
            headers: headers
        ).responseDecodable(of: [EpisodeView].self) { response in
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getHistoryMovie(completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            
            guard let historyWatch = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(historyWatch))
        }
    }
    
    func getEpisodesMovie(movieId: String, completion: @escaping (Result<[Episode], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/movies/\(movieId)/episodes",
            method: .get,
            headers: headers
        ).responseDecodable(of: [Episode].self) { response in
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getEpisodesMovie(movieId: movieId, completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            
                            self.keychain.synchronizable = true
                            self.keychain.clear()
                            
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            
            guard let episodes = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(episodes))
        }
    }
}
