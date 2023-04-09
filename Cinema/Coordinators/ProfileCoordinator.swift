//
//  ProfileCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Profile coordinator start")
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func generateProfileScreen() -> UIViewController {
        let vc = ProfileScreenViewController()
        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Профиль"
        vc.tabBarItem.image = UIImage(named: "TabItemProfileScreen")
        
        return vc
    }
    
    func goToDisscusionScreen() {
        
    }
    
    func goToHistoryScreen() {
        
    }
    
    func goToSettingsScreen() {
        
    }
    
    func goToAuthorizationScreen() {
        let appc = parentCoordinator as? HomeCoordinator
        
        appc?.goToAuthScreen()
        appc?.childDidFinish(self)
    }
}
