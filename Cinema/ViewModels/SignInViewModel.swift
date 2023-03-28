//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

protocol SignInNavigation: AnyObject {
    func goToSignUpScreen()
}

class SignInViewModel {
    weak var navigation: SignInNavigation?
    
    init(navigation: SignInNavigation) {
        self.navigation = navigation
    }
    
    func goToSignUp() {
        navigation?.goToSignUpScreen()
    }
    
}
