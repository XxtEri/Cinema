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
        goToChatList()
    }
}

extension ChatCoordinator: ChatNavigation {
    func goToChat() {
        let vc = ChatScreenViewController()
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToChatList() {
        let vc = ChatListScreenViewController()
        vc.viewModel = ChatViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToProfileScreen() {
        navigationController.popViewController(animated: true)
    }
}

