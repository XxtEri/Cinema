//
//  Message.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

struct MessageServer: Decodable {
    let messageId: String
    let creationDateTime: String
    let authorId: String?
    let authorName: String
    let authorAvatar: String?
    let text: String
}
