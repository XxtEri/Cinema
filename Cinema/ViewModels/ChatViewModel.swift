//
//  ChatViewModel.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

class ChatViewModel {
    private let api: IApiRepositoryChatScreen
    weak var navigation: ChatNavigation?
    
    var userId = Observable<String>()
    var chats = Observable<[Chat]>()
    var newMessages = Observable<MessageServer>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: ChatNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToChatListScreen() {
        navigation?.goToChatList()
    }
    
    func goToChatScreen(chatModel: Chat) {
        navigation?.goToChat(chatModel: chatModel)
    }
    
    func backGoToChatList() {
        navigation?.backGoToChatList()
    }
}

private extension ChatViewModel {
    func successLoadingHandle(with chats: [Chat]) {
        self.chats.updateModel(with: chats)
    }
    
    func successLoadingHandle(with message: MessageServer) {
        self.newMessages.updateModel(with: message)
    }
    
    func successLoadingHandle(with userId: String) {
        self.userId.updateModel(with: userId)
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
    
    func connectToChat(chatId: String) {
        self.api.connectToChat(chatId: chatId) { result in
            switch result {
            case .success(let message):
                self.successLoadingHandle(with: message)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
    
    func sendMessage(chatId: String, message: String) {
        self.api.sendMessage(chatId: chatId, message: message) { result in
            switch result {
            case .success(_):
                print("Success")
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
    
    func disconnectToChat() {
        self.api.disconnectChat()
    }
    
    func getUserId() {
        self.api.getUserId { result in
            switch result {
            case .success(let userId):
                self.successLoadingHandle(with: userId)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}

