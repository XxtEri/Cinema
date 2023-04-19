//
//  WebSocketClient.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import Foundation
import KeychainSwift

class WebSocketManager {
    var webSocket: URLSessionWebSocketTask?
    var keychain: KeychainSwift
    
    init() {
        self.keychain = KeychainSwift()
    }
    
    func connect(chatId: String, completion: @escaping (Result<MessageServer, Error>) -> Void) {
        let urlSession = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: "ws://107684.web.hosting-russia.ru:8000/api/chats/\(chatId)/messages")!)
        
        self.keychain.synchronizable = true
        guard let token = self.keychain.get("accessToken") else { return }
        
        // Добавляем токен в заголовки запроса
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        webSocket = urlSession.webSocketTask(with: request)
        webSocket?.resume()
        
        receiveMessage(completion: completion)
    }
    
    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error.localizedDescription)")
            }
        })
    }
    
    func receiveMessage(completion: @escaping (Result<MessageServer, Error>) -> Void) {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let message):
                    if let data = message.data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let message = try decoder.decode(MessageServer.self, from: data)
                            //print("Декодированный объект: \(message)")
                            completion(.success(message))
                            
                        } catch {
                            print("Ошибка декодирования объекта: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                case .data(_):
                    return
                @unknown default:
                    return
                }
                
                self?.receiveMessage(completion: completion)
            case .failure(let error):
                print("WebSocket receive failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        })
    }
    
    func sendMessage(text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let message = URLSessionWebSocketTask.Message.string(text)
        
        webSocket?.send(message) { error in
            if let error = error {
                print("Failed to send WebSocket message: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("WebSocket message sent successfully")
                completion(.success(()))
            }
        }
    }
    
    func disconnect() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
    }
}
