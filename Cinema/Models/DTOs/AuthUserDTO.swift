//
//  UserDto.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import Foundation

struct LoginCredentialDTO: Encodable {
    let email: String
    let password: String
}

struct RegisterCredentialDTO: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let confirmPassword: String
}

