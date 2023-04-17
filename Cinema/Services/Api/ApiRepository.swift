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

extension ApiRepository: IApiRepositoryAuthScreen {
    func signIn(user: LoginCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void) {
        
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
                if statusCode == 401 {
                    completion(.success(RequestStatus.notAuthorized))
                    return
                }
            }
            
            guard let token = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            self.keychain.synchronizable = true
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            
            self.getInformationProfile { result in
                switch result {
                case .success(let user):
                    self.keychain.set("\(user.userId)", forKey: "userId")
                case .failure(_):
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                }
            }
            
            print(token)

            completion(.success(RequestStatus.success))
        }
    }
    
    func signUp(user: RegisterCredential, completion: @escaping (Result<RequestStatus, Error>) -> Void) {
        
        self.requestStatus = .notSend
        
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
                if statusCode == 401 {
                    self.requestStatus = .notAuthorized
                    completion(.success(RequestStatus.notAuthorized))
                    return
                }
            }
            
            guard let token = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            self.keychain.synchronizable = true
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            
            print(token)

            completion(.success(RequestStatus.success))
        }
    }
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
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

extension ApiRepository: IApiRepositoryCollectionScreen {
    func getCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections",
            method: .get,
            headers: headers
        ).responseDecodable(of: [Collection].self) { response in
                
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getCollections(completion: completion)
                        case .failure(let error):
                            self.requestStatus = .notAuthorized
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
            }
            
            guard let collections = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(collections))
        }
    }
    
    func addNewCollection(collection: CollectionForm, completion: @escaping (Result<Collection, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections",
            method: .post,
            parameters: collection,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).responseDecodable(of: Collection.self) { response in
                
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.addNewCollection(collection: collection, completion: completion)
                        case .failure(let error):
                            self.requestStatus = .notAuthorized
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
            }
            
            guard let collection = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(collection))
        }
    }
    
    func deleteCollection(collectionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections/\(collectionId)",
            method: .delete,
            headers: headers
        ).responseData { response in
                
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.deleteCollection(collectionId: collectionId, completion: completion)
                        case .failure(let error):
                            self.requestStatus = .notAuthorized
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
            }
            
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesInCollection(collectionId: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
    }
    
    func addMoviesInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func deleteMovieInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
}

extension ApiRepository: IApiRepositoryProfileScreen {
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
    
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    
}
