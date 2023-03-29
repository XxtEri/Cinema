//
//  Navigation.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

protocol SignInNavigation: AnyObject {
    func goToSignUpScreen()
}

protocol SignUpNavigation: AnyObject {
    func goToSignInScreen()
}
