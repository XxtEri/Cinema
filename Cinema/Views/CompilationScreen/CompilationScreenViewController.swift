//
//  CompilationScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class CompilationScreenViewController: UIViewController {
    
    private let ui: CompilationScreenView
    
    var viewModel: CompilationScreenViewModel?
    
    init() {
        self.ui = CompilationScreenView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindListener()
        handler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getCompilation()
    }
}

extension CompilationScreenViewController {
    func bindListener() {
        self.viewModel?.compilationMovie.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            self.ui.updateArrayCardsMovie(cards: movies)
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            guard let self = self else { return }
            
            self.showError(error)
        })
        
        self.ui.cardCompilation.disappearedCard = { [ weak self ] in
            guard let self = self else { return }
            
            self.ui.updateCard()
        }
    }
    
    func handler() {
        self.ui.likeToMovieButtonPressed = { [ weak self ] movie in
            guard let self = self else { return }
            
            self.viewModel?.setLikeToMove(movie: movie)
        }
        
        self.ui.playMovieButtonPressed = { [ weak self ] movie in
            guard let self = self else { return }
            
            self.viewModel?.goToMovieScreen(movie: movie)
        }
        
        self.ui.dislikeToMovieButtonPressed = { [ weak self ] movie in
            guard let self = self else { return }
            
            self.viewModel?.deleteMovieInCollection(movieId: movie.movieId)
        }
        
        self.ui.cardCompilation.likeToMovieButtonPressed = { [ weak self ] movie in
            guard let self = self else { return }
            
            self.viewModel?.setLikeToMove(movie: movie)
        }
        
        self.ui.cardCompilation.dislikeToMovieButtonPressed = { [ weak self ] movie in
            guard let self = self else { return }
            
            self.viewModel?.deleteMovieInCollection(movieId: movie.movieId)
        }
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
}
