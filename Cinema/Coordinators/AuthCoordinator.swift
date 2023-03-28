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
        goToSignInScreen()
    }
}

extension AuthCoordinator: SignInNavigation, SignUpNavigation {
    func goToSignUpScreen() {
        let vc = SingUpViewController()
        let viewModel = SignUpViewModel(navigation: self)
        
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSignInScreen() {
        let vc = SignInViewController()
        let viewModel = SignInViewModel(navigation: self)
        
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
    
}
