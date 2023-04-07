//
//  CompilationScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

class CompilationScreenViewModel {
    private let api: IApiRepositoryCompilationScreen
    weak var navigation: CompilationNavigation?
    
    var compilationMovie = Observable<[Movie]>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: CompilationNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
}

private extension CompilationScreenViewModel {
    func successLoadingHandle(with movies: [Movie]) {
        self.compilationMovie.updateModel(with: movies)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension CompilationScreenViewModel: ICompulationViewModel {
    func getCompilation() {
        self.api.getCompilationMovies { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}
