//
//  ProfileViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

class ProfileScreenViewModel {
    private let api: IApiRepositoryProfileScreen
    weak var navigation: ProfileScreenNavigation?
    
    var informationProfile = Observable<User>()
    var errorOnLoading = Observable<Error>()
    
    var changeData: ((User) -> Void)?
    
    init(navigation: ProfileScreenNavigation?) {
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

private extension ProfileScreenViewModel {
    func successLoadingHandle(with informationUser: User) {
        self.informationProfile.updateModel(with: informationUser)
        self.changeData?(informationUser)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension ProfileScreenViewModel: IProfileViewModel {
    func getInformationProfile() {
        self.api.getInformationProfile { result in
            switch result {
            case .success(let user):
                self.successLoadingHandle(with: user)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
    
    func signOut() {
        //очистить данные пользователя
    }
}

