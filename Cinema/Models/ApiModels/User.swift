//
//  User.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

struct User: Decodable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    let avatar: String?
}
