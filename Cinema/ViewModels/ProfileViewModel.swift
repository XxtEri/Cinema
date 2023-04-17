//
//  ProfileViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

class ProfileViewModel {
    private let api: ApiRepository
    private var service: CollectionService
    
    weak var navigation: ProfileNavigation?
    
    var informationProfile = Observable<User>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: ProfileNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
        self.service = CollectionService()
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
                    self.service.clearDatabase()
                    navigation?.goToAuthorizationScreen()
                } else {
                    failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func editAvatarProfile(imageUrl: URL) {
        print(imageUrl)
        self.api.uploadPhoto(imageUrl: imageUrl) { [ self ] result in
            switch result {
            case .success():
                getInformationProfile()
            case .failure(let error):
                if api.requestStatus == .notAuthorized {
                    self.service.clearDatabase()
                    navigation?.goToAuthorizationScreen()
                } else {
                    failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func signOut() {
        service.clearDatabase()
        navigation?.goToAuthorizationScreen()
    }
}
