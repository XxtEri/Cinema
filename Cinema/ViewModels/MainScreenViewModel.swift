//
//  MainScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

class MainScreenViewModel {
    private let api: IApiRepositoryMainScreen
    weak var navigation: MainScreenNavigation?
    
    var coverMovie = Observable<CoverMovie>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: MainScreenNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
}

private extension MainScreenViewModel {
    func successLoadingHandle(with coverImageMovie: CoverMovie) {
        self.coverMovie.updateModel(with: coverImageMovie)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension MainScreenViewModel: IMainScreenViewModel {
    func getCoverImage() {
        self.api.getCoverFilm { result in
            switch result {
            case .success(let coverImageMovie):
                self.successLoadingHandle(with: coverImageMovie)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}
