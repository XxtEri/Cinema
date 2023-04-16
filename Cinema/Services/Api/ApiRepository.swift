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
    
    var webSocketManager: WebSocketManager
    
    private let keychain: KeychainSwift
    
    private let baseURL = "http://107684.web.hosting-russia.ru:8000/api"
    
    init() {
        self.session = .default
        self.keychain = KeychainSwift()
        self.webSocketManager = WebSocketManager()
    }
}

extension ApiRepository: IApiRepositoryAuthScreen {
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
            guard let userId = self.keychain.get("userId") else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                
                return
            }
            
            self.keychain.clear()
            
            self.keychain.set("\(token.accessToken)", forKey: "accessToken")
            self.keychain.set("\(token.refreshToken)", forKey: "refreshToken")
            self.keychain.set("\(userId)", forKey: "userId")
            
            print(token)
            
            completion(.success(()))
        }
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
                    self.keychain.synchronizable = true
                    self.keychain.clear()
                }
            }
            
            guard let user = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            if self.keychain.get("userId") == nil {
                self.keychain.set("\(user.userId)", forKey: "userId")
            }
            
            completion(.success(user))
        }
    }
    
    func editInformationProfile(completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void) {
        
    }
}

extension ApiRepository: IApiRepositoryChatScreen {
    func getChatList(completion: @escaping (Result<[Chat], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/chats",
            method: .get,
            headers: headers
        ).responseDecodable(of: [Chat].self) { response in
                
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getChatList(completion: completion)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
            }
            
            guard let chats = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(chats))
        }
    }
    
    func connectToChat(chatId: String, completion: @escaping (Result<MessageServer, Error>) -> Void) {
        webSocketManager.connect(chatId: chatId, completion: completion)
    }
    
    func sendMessage(chatId: String, message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        webSocketManager.sendMessage(text: message, completion: completion)
    }
    
    func disconnectChat() {
        webSocketManager.disconnect()
    }
    
    func getUserId(completion: @escaping (Result<String, Error>) -> Void) {
        self.keychain.synchronizable = true
        
        if let userId = self.keychain.get("userId") {
            completion(.success(userId))
            
            return
        }
        
        completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
    }
}
