//
//  AuthCoordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

final class AuthCoordinator: Coordinator {

    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Authorization start")
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            goToSignInScreen()
        } else {
            goToSignUpScreen()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
}

extension AuthCoordinator: AuthNavigation {
    func goToHomeScreen() {
        let appc = parentCoordinator as? AppCoordinator
        
        appc?.goToHome()
        appc?.childDidFinish(self)
    }
    
    func goToSignUpScreen() {
        let vc = SingUpViewController()

        vc.viewModel = AuthViewModel(navigation: self)
        vc.navigationItem.hidesBackButton = true
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSignInScreen() {
        let vc = SignInViewController()

        vc.viewModel = AuthViewModel(navigation: self)
        vc.navigationItem.hidesBackButton = true
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
}
