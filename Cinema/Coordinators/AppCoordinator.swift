//
//  AppCoordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("App coordinator start")
//        goToAuth()
        goToMain()
    }
    
    func goToAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    func goToMain() {
        let vc = TabBarViewController()
        
        navigationController.pushViewController(vc, animated: true)
    }
}
