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
    func goToMovieScreen(movie: Movie)
    func goToEpisodeScreen(movie: Movie, epidose: Episode)
    func goToAuthorizationScreen()
}

protocol ProfileNavigation: AnyObject {
    func goToDisscusionScreen()
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}
