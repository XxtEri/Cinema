//
//  IProfileViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

protocol IProfileViewModel {
    var informationProfile: Observable<User> { get }
    var errorOnLoading: Observable<Error> { get }
    
    func getInformationProfile()
    func signOut()
}
