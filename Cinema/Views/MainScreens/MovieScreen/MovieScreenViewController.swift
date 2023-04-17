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
        handler()
        
        viewModel?.getEpisodesMovie(movieId: movie.movieId)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.ui.episodesMovie.episodesMovie.addObserver(self.ui.episodesMovie, forKeyPath: "contentSize", options: .new, context: nil)
//        self.ui.episodesMovie.episodesMovie.reloadData()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.ui.episodesMovie.episodesMovie.removeObserver(self.ui.episodesMovie, forKeyPath: "contentSize")
//    }
//
//    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize" {
//            if let newValue = change?[.newKey] { [ self ]
//                let newSize = newValue as! CGSize
//                self.episodesMovie.tableViewHeight = newSize.width
//            }
//        }
//    }
    
    @objc
    private func customButtonTapped() {
        print("Кастомная кнопка на навигационном баре нажата")
    }
}

extension MovieScreenViewController {
    func bindListener() {
        self.viewModel?.episodesMovie.subscribe(with: { [ weak self ] episodes in
            guard let self = self else { return }
            
            self.ui.setEpisodes(episodes: episodes)
        })
    }
    
    func handler() {
        self.ui.episodesMovie.episodePressed = { [ weak self ] (currentEpisode, episodes) in
            guard let self = self else { return }
            
            self.viewModel?.goToEpisodeScreen(movie: self.movie, episode: currentEpisode, episodes: episodes)
        }
        
        self.ui.backToGoMainScreen = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.backToGoLastScreen()
        }
    }
}
