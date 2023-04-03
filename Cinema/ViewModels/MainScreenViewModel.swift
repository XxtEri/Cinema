//
//  MainScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

class MainScreenViewModel {
    private let api: IApiRepositoryProfileScreen
    weak var navigation: MainScreenNavigation?
    
    var coverMovie = Observable<CoverMovie>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: MainScreenNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
}
