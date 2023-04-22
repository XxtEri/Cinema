//
//  CompilationScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class CompilationScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private let ui: CompilationScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: CompilationScreenViewModel?
    
    
    //- MARK: Inits
    
    init() {
        self.ui = CompilationScreenView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Lifecycle
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindListener()
        handler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.viewModel?.getCompilation()
        }
    }
    
    
    //- MARK: Private methods
    
    private func showActivityIndicator() {
        self.ui.startAnumateIndicator()
    }
    
    private func hideActivityIndicator() {
        self.ui.stopAnimateIndicator()
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Внимание!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { action in }
        
        alertController.addAction(action)
        
        alertController.view.tintColor = .accentColorApplication
        
        self.present(alertController, animated: true, completion: nil)
    }
}


//- MARK: Private extensions

private extension CompilationScreenViewController {
    func bindListener() {
        self.viewModel?.compilationMovie.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            self.ui.updateArrayCardsMovie(cards: movies)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.hideActivityIndicator()
            }
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            self.showError("Неизвестная ошибка сервера. Попробуйте еще раз позже")
        })
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
        
        self.ui.cardCompilation.disappearedCard = { [ weak self ] in
            guard let self = self else { return }
            
            self.ui.updateCard()
            
        }
    }
}
