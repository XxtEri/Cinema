//
//  MovieScreenViewController.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class MovieScreenViewController: UIViewController {
    
    private var ui: MovieScreenView
    
    var viewModel: MainViewModel?
    
    var movie: Movie
    
    init(movie: Movie) {
        self.ui = MovieScreenView()
        self.movie = movie
        
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
        
        self.ui.setMovie(movie: movie)
        
        bindListener()
        
        viewModel?.getEpisodesMovie(movieId: movie.movieId)
    }
}

extension MovieScreenViewController {
    func bindListener() {
        self.viewModel?.episodesMovie.subscribe(with: { [ weak self ] episodes in
            guard let self = self else { return }
            
            self.ui.setEpisodes(episodes: episodes)
        })
    }
}
