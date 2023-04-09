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
    
    func generateProfileScreen() -> UIViewController {
        let vc = ProfileScreenViewController()
        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Профиль"
        vc.tabBarItem.image = UIImage(named: "TabItemProfileScreen")
        
        return vc
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func goToDisscusionScreen() {
        let vc = ChatListScreenViewController()
        
        
//        let customArrowBack = UIImage(named: "ArrowBack")
//        navigationController.navigationBar.backIndicatorImage = UIImage(named: "ArrowBack")
//        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ArrowBack")
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToHistoryScreen() {
        
    }
    
    func goToSettingsScreen() {
        
    }
    
    func goToAuthorizationScreen() {
        
    }
}
