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
    var trendsMovie = Observable<[Movie]>()
    var alreadyWatchMovie = Observable<[Movie]>()
    var newMovie = Observable<[Movie]>()
    var recomendationMovie = Observable<[Movie]>()
    var compilationMovie = Observable<[Movie]>()
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
    
    func successLoadingHandle(with movies: Movies, typeListMovie: TypeListMovie) {
        switch typeListMovie {
        case .trend:
            self.trendsMovie.updateModel(with: movies.movies)
        case .alreadyWatch:
            self.alreadyWatchMovie.updateModel(with: movies.movies)
        case .new:
            self.newMovie.updateModel(with: movies.movies)
        case .recomendation:
            self.recomendationMovie.updateModel(with: movies.movies)
        case .compilation:
            self.compilationMovie.updateModel(with: movies.movies)
        }
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
    
    func getMovies() {
        self.api.getMovies(typeListMovie: .trend) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .trend)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getMovies(typeListMovie: .alreadyWatch) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .alreadyWatch)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getMovies(typeListMovie: .new) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .new)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        self.api.getMovies(typeListMovie: .new) { result in
            switch result {
            case .success(let movies):
                self.successLoadingHandle(with: movies, typeListMovie: .new)
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}
