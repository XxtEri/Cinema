//
//  ChatCoordinator.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

final class ChatCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Chat coordinator start")
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        goToChatList()
    }
}

extension ChatCoordinator: ChatNavigation {
    func goToChatList() {
        let vc = ChatListScreenViewController()
        vc.viewModel = ChatViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToChat(chatModel: Chat) {
        let vc = ChatScreenViewController(chatModel: chatModel)
        vc.viewModel = ChatViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backGoToLastScreen() {
        self.navigationController.popViewController(animated: true)
    }
}

