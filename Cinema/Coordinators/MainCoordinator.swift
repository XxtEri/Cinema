//
//  MainCoordinator.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Main coordinator start")
        goToMain()
    }
    
    func goToMain() {
        let vc = TabBarViewController()

        navigationController.pushViewController(vc, animated: true)
    }
}
