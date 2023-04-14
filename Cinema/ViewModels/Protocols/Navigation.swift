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

protocol CollectionsNavigation: AnyObject {
    func goToCreateEditingCollectionScreen(isCreatingCollection: Bool, titleCollection: String?)
    func backGoToCreateEditingCollectionScreen()
    func goToIconSelectionScreen(delegate: SheetViewControllerDelegate)
    func goToCollectionsScreen()
    func goToCollectionScreenDetail(titleCollection: String)
}

protocol ProfileNavigation: AnyObject {
    func goToDisscusionScreen()
    func goToHistoryScreen()
    func goToSettingsScreen()
    func goToAuthorizationScreen()
}
