//
//  IChatViewModel.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

protocol IChatViewModel {
    func getChatList()
    func connectToChat(chatId: String)
    func disconnectToChat()
    func getUserId()
}
