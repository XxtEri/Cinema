//
//  AppCoordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("App coordinator start")
        goToAuth()
    }
    
    func goToAuth() {
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
