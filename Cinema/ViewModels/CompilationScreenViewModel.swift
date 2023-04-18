//
//  CompilationScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//
import Foundation

class CompilationScreenViewModel {
    private let api: ApiRepository
    private let collectionService: CollectionService
    weak var navigation: CompilationNavigation?
    
    var compilationMovie = Observable<[Movie]>()
    var errorOnLoading = Observable<Error>()
    
    var moviesFavoriteCollection = [Movie]()
    
    init(navigation: CompilationNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
        self.collectionService = CollectionService()
    }
    
    func goToMovieScreen(movie: Movie) {
        navigation?.goToMovieScreen(movie: movie)
    }
}

private extension CompilationScreenViewModel {
    func successLoadingHandle(with movies: [Movie]) {
        self.compilationMovie.updateModel(with: movies)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
    
    func getFavoriteCollectionId() -> String{
        var favoriteCollectionId = String()
        self.collectionService.getFavoriteCollectionId { result in
            switch result {
            case .success(let id):
                if let collecitonId = id {
                    favoriteCollectionId = collecitonId
                }
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
        
        return favoriteCollectionId
    }
    
    func getMoviesFavoriteCollection(favoriteCollectionId: String) {
        self.api.getMovieInCollection(collectionId: favoriteCollectionId) { result in
            switch result {
            case .success(let movies):
                self.moviesFavoriteCollection = movies
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}

extension CompilationScreenViewModel: ICompulationViewModel {
    func getCompilation() {
        self.api.getCompilationMovies { [ self ] result in
            switch result {
            case .success(let movies):
                successLoadingHandle(with: movies)
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
    
    func setLikeToMove(movie: Movie) {
        let favoriteCollectionId = self.getFavoriteCollectionId()
        
        DispatchQueue.main.async {
            self.api.addMovieToColletion(collectionId: favoriteCollectionId, movieValue: MovieValue(movieId: movie.movieId)) { result in
                switch result {
                case .success(_):
                    return
                case .failure(let error):
                    self.failureLoadingHandle(with: error)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.setDislike(favoriteCollectionId: favoriteCollectionId, movieId: movie.movieId)
        }
    }
    
    func deleteMovieInCollection(movieId: String) {
        let favoriteCollectionId = getFavoriteCollectionId()
        
        DispatchQueue.main.async {
            self.api.deleteMovieInCollection(collectionId: favoriteCollectionId, movieId: movieId) { result in
                switch result {
                case .success(_):
                    print("success")
                case .failure(let error):
                    self.failureLoadingHandle(with: error)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.setDislike(favoriteCollectionId: favoriteCollectionId, movieId: movieId)
        }
    }
    
    func setDislike(favoriteCollectionId: String, movieId: String) {
        self.api.setDislikeMovie(movieId: movieId) { [ self ] result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
}
