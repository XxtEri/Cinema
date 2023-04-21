//
//  CustomRequestIntercepter.swift
//  Cinema
//
//  Created by Елена on 21.04.2023.
//

import Alamofire
import UIKit

class CustomRequestIntercepter: RequestInterceptor {
    private let refreshToken: String

    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        
        
        var request = urlRequest
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
}
