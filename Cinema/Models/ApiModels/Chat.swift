//
//  Chat.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

struct Chat: Decodable {
    let chatId: String
    let chatName: String
    let lastMessage: MessageServer
}

