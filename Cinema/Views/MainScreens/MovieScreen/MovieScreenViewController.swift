//
//  MovieScreenViewController.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class MovieScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private var ui: MovieScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: MainViewModel?
    var movie: Movie
    
    
    //- MARK: Inits
    
    init(movie: Movie) {
        self.ui = MovieScreenView()
        self.movie = movie
        
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
        
        self.ui.setMovie(movie: movie)
        
        bindListener()
        handler()
        
        viewModel?.getEpisodesMovie(movieId: movie.movieId)
    }
}


//- MARK: Private extensions

private extension MovieScreenViewController {
    func bindListener() {
        self.viewModel?.episodesMovie.subscribe(with: { [ weak self ] episodes in
            guard let self = self else { return }
            
            self.ui.setEpisodes(episodes: episodes)
        })
    }
    
    func handler() {
        self.ui.content.episodesMovie.episodePressed = { [ weak self ] (currentEpisode, episodes) in
            guard let self = self else { return }
            
            self.viewModel?.goToEpisodeScreen(movie: self.movie, episode: currentEpisode, episodes: episodes)
        }
        
        self.ui.barBackButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.backToGoLastScreen()
        }
        
        self.ui.discussionsImagePressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToChatMovie(chatModel: self.movie.chatInfo)
        }
    }
}
