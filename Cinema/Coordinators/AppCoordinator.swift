//
//  AppCoordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit
import KeychainSwift

final class AppCoordinator: Coordinator {
    private var keychain: KeychainSwift
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []

    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.keychain = KeychainSwift()
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        print("App coordinator start")
        
        keychain.synchronizable = true

        if keychain.get("accessToken") != nil {
            goToHome()

        } else {
            goToAuth()
        }
    }
    
    func goToAuth() {
        keychain.clear()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    func goToHome() {
        let mainCoordinator = HomeCoordinator(navigationController: navigationController)
        
        mainCoordinator.parentCoordinator = self
        children.append(mainCoordinator)
        
        mainCoordinator.start()
    }
}
