//
//  ApiRepository.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation
import Alamofire

protocol IApiRepository {
    func signIn(user: LoginCredential, completion: @escaping (Result<AuthTokenPair, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<AuthTokenPair, Error>) -> Void)
}

class ApiRepository {
    private let baseURL = "http://107684.web.hosting-russia.ru:8000/api/"
    
    private let session: Alamofire.Session
    
    init() {
        self.session = .default
    }
}

extension ApiRepository: IApiRepository {
    func signIn(user: LoginCredential, completion: @escaping (Result<AuthTokenPair, Error>) -> Void) {
        
        self.session.request(
            "\(baseURL)auth/login",
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.default
        ).response { response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(String(describing: statusCode))")
            }
            
            switch response.result {
            case .success(let data):
                do {
                    guard let data = data else { return }
                    
                    let token = try JSONDecoder().decode(AuthTokenPair.self, from: data)
    
                    completion(.success(token))
                    
                } catch (_) {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }
            case .failure(_):
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
        }
    }
    
    func signUp(user: RegisterCredential, completion: @escaping (Result<AuthTokenPair, Error>) -> Void) {
        
        self.session.request(
            "\(baseURL)auth/register",
            method: .post,
            parameters: user,
            encoder: JSONParameterEncoder.default
        ).response { response in
            
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(String(describing: statusCode))")
            }
            
            switch response.result {
            case .success(let data):
                do {
                    guard let data = data else { return }
                    
                    let token = try JSONDecoder().decode(AuthTokenPair.self, from: data)
    
                    completion(.success(token))
                    
                } catch (_) {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }
            case .failure(_):
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
        }
    }
}
