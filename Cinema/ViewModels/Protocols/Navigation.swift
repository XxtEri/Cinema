//
//  Navigation.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

protocol SignNavigation: AnyObject {
    func goToSignInScreen()
    func goToSignUpScreen()
    func goToHomeScreen()
}

protocol HomeNavigation: AnyObject {
    func goToHomeScreen()
}

protocol ProfileNavigation: AnyObject {
    func goToDisscusionScreen()
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}
