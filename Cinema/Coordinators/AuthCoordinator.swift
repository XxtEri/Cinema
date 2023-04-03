//
//  AuthCoordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

class AuthCoordinator: Coordinator {
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
            print("Not first launch.")
            goToSignInScreen()
        } else {
            print("First launch, setting UserDefault.")
            goToSignUpScreen()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
}

extension AuthCoordinator: SignNavigation {
    func goToHomeScreen() {
        
    }
    
    func goToSignUpScreen() {
        let vc = SingUpViewController()
        let viewModel = SignViewModel(navigation: self)
        
        vc.viewModel = viewModel
        vc.navigationItem.hidesBackButton = true
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSignInScreen() {
        let vc = SignInViewController()
        let viewModel = SignViewModel(navigation: self)
        
        vc.viewModel = viewModel
        vc.navigationItem.hidesBackButton = true
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMainScreen() {
        let vc = TabBarViewController()
        
        vc.navigationItem.hidesBackButton = true
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
}
