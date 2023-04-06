//
//  MainScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private var ui: MainScreenView
    
    var viewModel: MainScreenViewModel?
    
    //- MARK: Initial
    
    init() {
        self.ui = MainScreenView()
        
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
        
        viewModel?.getCoverImage()
        viewModel?.getMovies()
    }
}

extension MainScreenViewController {
    func bindListener() {
        self.viewModel?.coverMovie.subscribe(with: { [ weak self ] cover in
            guard let self = self else { return }
            
            self.ui.setCoverImageMoview(with: cover)
        })
        
        self.viewModel?.trendsMovie.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            self.ui.content.setMovieImageInTrendBlock(with: movies)
        })
        
        self.viewModel?.lastWatchMovies.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            if movies.isEmpty {
                self.ui.content.setLastWatchMovie(with: nil)
                
            } else {
                self.ui.content.setLastWatchMovie(with: movies[movies.endIndex - 1])
            }
        })
        
        self.viewModel?.newMovie.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            self.ui.content.setMovieImageInNewBlock(with: movies)
        })
        
        self.viewModel?.recomendationMovie.subscribe(with: { [ weak self ] movies in
            guard let self = self else { return }
            
            self.ui.content.setMovieImageRecomendationBlock(with: movies)
        })
        
        self.viewModel?.errorOnLoading.subscribe(with: { [ weak self ] error in
            guard let self = self else { return }
            
            self.showError(error)
        })
    }
    
    func showError(_ error: Error) {
        print(error.localizedDescription)
    }
}
