//
//  IProfileViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import Foundation

protocol IProfileViewModel {
    var informationProfile: Observable<User> { get }
    var errorOnLoading: Observable<Error> { get }
    
    func getInformationProfile()
    func editAvatarProfile(imageUrl: URL)
    func signOut()
}
