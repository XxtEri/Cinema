//
//  ApiRepository.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation
import Alamofire
import KeychainSwift
import UIKit

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
    
    func uploadPhoto(imageUrl: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
     
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        guard let fileData = readFileDataFromFileURL(fileURL: imageUrl) else { return }
        
        self.session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            },
            to: "\(baseURL)/profile/avatar",
            headers: headers)
        .response { response in
            if let request = response.request {
                print("Request: \(request)")
            }

            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.uploadPhoto(imageUrl: imageUrl, completion: completion)
                        case .failure(_):
//                            self.requestStatus = .notAuthorized
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            // Обработка результата загрузки
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                // Обработка ошибки загрузки файла
                print("Ошибка загрузки файла: \(error)")
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
            }
        }
    }
    
    func readFileDataFromFileURL(fileURL: URL) -> Data? {
        do {
            // Чтение данных из файла в память
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("Ошибка чтения файла: \(error.localizedDescription)")
            return nil
        }
    }
}
