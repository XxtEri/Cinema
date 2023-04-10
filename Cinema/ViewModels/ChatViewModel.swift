//
//  ChatViewModel.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

class ChatViewModel {
    private let api: ApiRepository
    weak var navigation: ChatNavigation?
    
    init(navigation: ChatNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToChatListScreen() {
        navigation?.goToChatList()
    }
    
    func goToChatScreen() {
        navigation?.goToChat()
    }
}
