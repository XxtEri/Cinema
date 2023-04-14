//
//  AuthTokenPair.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

struct AuthTokenPair: Decodable {
    let accessToken: String
    let accessTokenExpiresIn: Int

    let refreshToken: String
    let refreshTokenExpiresIn: Int
}
