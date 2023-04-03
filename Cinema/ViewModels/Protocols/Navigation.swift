//
//  Navigation.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

protocol SignScreenNavigation: AnyObject {
    func goToSignInScreen()
    func goToSignUpScreen()
    func goToHomeScreen()
}

protocol MainScreenNavigation: AnyObject {
    
}

protocol ProfileScreenNavigation: AnyObject {
    func goToDisscusionScreen()
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}
