//
//  MainScreenCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

final class MainCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Main coordinator start")
    }
}
