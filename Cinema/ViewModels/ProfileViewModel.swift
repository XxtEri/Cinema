//
//  ProfileViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

class ProfileViewModel {
    private let api: ApiRepository
    weak var navigation: ProfileNavigation?
    
    var informationProfile = Observable<User>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: ProfileNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToDisscusion() {
        navigation?.goToDisscusionScreen()
    }
    
    func goToHistory() {
        navigation?.goToHistoryScreen()
    }
    
    func goToSettings() {
        navigation?.goToSettingsScreen()
    }
    
    func goToAuthorization() {
        navigation?.goToAuthorizationScreen()
    }
}

private extension ProfileViewModel {
    func successLoadingHandle(with informationUser: User) {
        self.informationProfile.updateModel(with: informationUser)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension ProfileViewModel: IProfileViewModel {
    func getInformationProfile() {
        self.api.getInformationProfile { [ self ] result in
            switch result {
            case .success(let user):
                successLoadingHandle(with: user)
            case .failure(let error):
                if api.requestStatus == .notAuthorized {
                    navigation?.goToAuthorizationScreen()
                } else {
                    failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func signOut() {
        //очистить данные пользователя
    }
}

