//
//  SingUpViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

protocol SignUpNavigation: AnyObject {
    func goToSignInScreen()
}

class SignUpViewModel {
    weak var navigation: SignUpNavigation?
    
    init(navigation: SignUpNavigation) {
        self.navigation = navigation
    }
    
    func goToSingIn() {
        navigation?.goToSignInScreen()
    }
}
