//
//  Navigation.swift
//  Cinema
//
//  Created by Елена on 29.03.2023.
//

import Foundation

protocol AuthNavigation: AnyObject {
    func goToSignInScreen()
    func goToSignUpScreen()
    func goToHomeScreen()
}

protocol MainScreenNavigation: AnyObject {
    func goToMovieScreen(movie: Movie)
    func goToEpisodeScreen(movie: Movie, currentEpisode: Episode, episodes: [Episode])
    func backToGoLastScreen()
    func goToAuthorizationScreen()
}

protocol CollectionsNavigation: AnyObject {
    
}

protocol ProfileNavigation: AnyObject {
    func goToDisscusionScreen()
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}
