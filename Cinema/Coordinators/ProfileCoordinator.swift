//
//  ProfileCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import KeychainSwift

final class ProfileCoordinator: Coordinator {
    private var keychain: KeychainSwift
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.keychain = KeychainSwift()
    }
    
    func start() {
        print("Profile coordinator start")
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func generateProfileScreen() -> UIViewController {
        let vc = ProfileScreenViewController()
        vc.viewModel = ProfileScreenViewModel(navigation: self)
        
        vc.tabBarItem.title = "Профиль"
        vc.tabBarItem.image = UIImage(named: "TabItemProfileScreen")
        
        return vc
    }
    
    func goToChatListScreen() {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        
        chatCoordinator.parentCoordinator = self
        children.append(chatCoordinator)
        
        chatCoordinator.start()
    }
    
    func goToChatScreen(chatModel: Chat) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        
        chatCoordinator.parentCoordinator = self
        children.append(chatCoordinator)
        
        chatCoordinator.goToChat(chatModel: chatModel)
    }
    
    func goToHistoryScreen() {
        
    }
    
    func goToSettingsScreen() {
        
    }
    
    func goToAuthorizationScreen() {
        let appc = parentCoordinator as? HomeCoordinator
        
        keychain.synchronizable = true
        keychain.clear()
        
        appc?.goToAuthScreen()
        appc?.childDidFinish(self)
    }
}
