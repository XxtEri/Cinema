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
    
    var requestStatus: RequestStatus = .notSend
    
    init() {
        self.session = .default
        self.keychain = KeychainSwift()
        self.webSocketManager = WebSocketManager()
    }
}

extension ApiRepository: IApiRepositoryAuth {
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
    
    func getLastWatchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        let parameters: Parameters = [
            "filter" : TypeListMovieMainScreen.lastView
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
                            self.getLastWatchMovies(completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            
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
    
    func getCurrentEpisodeTime(episodeId: String, completion: @escaping (Result<EpisodeTime, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/episodes/\(episodeId)/time",
            method: .get,
            headers: headers
        ).responseDecodable(of: EpisodeTime.self) { response in
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.getCurrentEpisodeTime(episodeId: episodeId, completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized
                            
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            guard let time = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(time))
        }
    }
    
    func saveCurrentEpisodeTime(episodeId: String, time: EpisodeTime, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/episodes/\(episodeId)/time",
            method: .post,
            parameters: time,
            encoder: JSONParameterEncoder.default,
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
                            self.saveCurrentEpisodeTime(episodeId: episodeId, time: time, completion: completion)
                        case .failure(_):
                            self.requestStatus = .notAuthorized

                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
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
}

extension ApiRepository: IApiRepositoryCompilationScreen {
    func getCompilationMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        let parameters: Parameters = [
            "filter" : "compilation"
        ]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/movies",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: [Movie].self) { response in
            
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
            
            guard let movies = response.value else {
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                return
            }
            
            completion(.success(movies))
        }
    }
    
    func setDislikeMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]

        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/movies/\(movieId)/dislike",
            method: .delete,
            headers: headers
        ).response { response in
                
            if let request = response.request {
                print("Request: \(request)")
            }
            
            if let statusCode = response.response?.statusCode {
                print("Status code: \(statusCode)")
                if statusCode == 401 {
                    self.refreshToken { result in
                        switch result {
                        case .success(_):
                            self.setDislikeMovie(movieId: movieId, completion: completion)
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
    
    func addMovieToColletion(collectionId: String, movieValue: MovieValue, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections/\(collectionId)/movies",
            method: .post,
            parameters: movieValue,
            encoder: JSONParameterEncoder.default,
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
                            self.addMovieToColletion(collectionId: collectionId, movieValue: movieValue, completion: completion)
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
    
    func deleteMovieInCollection(collectionId: String, movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        let parameters: Parameters = [
            "movieId" : "\(movieId)"
        ]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections/\(collectionId)/movies",
            method: .delete,
            parameters: parameters,
            encoding: URLEncoding.queryString,
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
                            self.deleteMovieInCollection(collectionId: collectionId, movieId: movieId, completion: completion)
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
    
    func getMovieInCollection(collectionId: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        var headers: HTTPHeaders = [:]
        
        self.keychain.synchronizable = true
        if let token = self.keychain.get("accessToken") {
            headers["Authorization"] = "Bearer " + token
        }
        
        self.session.request(
            "\(baseURL)/collections/\(collectionId)/movies",
            method: .get,
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
                            self.getMovieInCollection(collectionId: collectionId, completion: completion)
                        case .failure(let error):
                            self.requestStatus = .notAuthorized
                            completion(.failure(error))
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
            
            if self.keychain.get("userId") == nil {
                self.keychain.set("\(user.userId)", forKey: "userId")
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
                            self.requestStatus = .notAuthorized
                            completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                        }
                    }
                    
                    return
                }
            }
            
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                print("Ошибка загрузки файла: \(error)")
                completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
            }
        }
    }
    
    func readFileDataFromFileURL(fileURL: URL) -> Data? {
        do {
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("Ошибка чтения файла: \(error.localizedDescription)")
            return nil
        }
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
