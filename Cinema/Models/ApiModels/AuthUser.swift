//
//  User.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

struct LoginCredential: Encodable {
    let email: String
    let password: String
}

struct RegisterCredential: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
