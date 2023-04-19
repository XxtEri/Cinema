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
    func goToChatMovie(chatModel: Chat)
    func goToAuthorizationScreen()
}

protocol CollectionsNavigation: AnyObject {
    func goToCreateEditingCollectionScreen(isCreatingCollection: Bool, collection: CollectionList?)
    func backGoToCreateEditingCollectionScreen()
    func goToIconSelectionScreen(delegate: SheetViewControllerDelegate)
    func goToCollectionsScreen()
    func goToLastScreen()
    func goToCollectionScreenDetail(collection: CollectionList)
    func goToMovieScreen(movie: Movie)
    func goToAuthorizationScreen()
}

protocol CompilationNavigation: AnyObject {
    func goToMovieScreen(movie: Movie)
    func goToAuthorizationScreen()
}

protocol ProfileNavigation: AnyObject {
    func goToChatListScreen()
    func goToChatScreen(chatModel: Chat)
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}

protocol ChatNavigation: AnyObject {
    func goToChatList()
    func goToChat(chatModel: Chat)
    func backGoToLastScreen()
}
