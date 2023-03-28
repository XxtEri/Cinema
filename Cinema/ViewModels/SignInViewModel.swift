//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

protocol SignInNavigation: AnyObject {
    func goToSignInScreen()
}

class SignInViewModel {
    weak var navigation: SignInNavigation?
    
    init(navigation: SignInNavigation) {
        self.navigation = navigation
    }
    
    func goToRegister() {
        navigation?.goToSignInScreen()
    }
    
}
