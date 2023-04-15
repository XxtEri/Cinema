//
//  ChatViewModel.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

class ChatViewModel {
    private let api: IApiRepositoryChatScreen
    weak var navigation: ChatNavigation?
    
    var chats = Observable<[Chat]>()
    var errorOnLoading = Observable<Error>()
    
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

private extension ChatViewModel {
    func successLoadingHandle(with chats: [Chat]) {
        self.chats.updateModel(with: chats)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension ChatViewModel: IChatViewModel {
    func getChatList() {
        self.api.getChatList { result in
            switch result {
            case .success(let chats):
                self.successLoadingHandle(with: chats)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}

