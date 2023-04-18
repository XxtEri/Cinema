//
//  EpisodeScreenViewController.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

class EpisodeScreenViewController: UIViewController {

    private let ui: EpisodeScreenView
    
    var viewModel: MainViewModel?
    
    var movie: Movie
    
    var currentEpisode: Episode
    
    var episodes: [Episode]

    init(movie: Movie, currentEpisode: Episode, episodes: [Episode]) {
        self.ui = EpisodeScreenView()
        self.movie = movie
        self.currentEpisode = currentEpisode
        self.episodes = episodes

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
        
        self.navigationController?.isNavigationBarHidden = true
        
        handler()

        self.ui.configureUIData(movie: movie, episode: currentEpisode)
        self.ui.setYearsMovie(episodes: episodes)
        
        self.viewModel?.getEpisodeTime(episodeId: currentEpisode.episodeId)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        self.ui.videoPlayerView.playerLayer?.frame = self.ui.videoPlayerView.videoView.bounds
    }
}

extension EpisodeScreenViewController {
    func handler() {
        self.ui.buttonBackGoToLastScreenPressed = { [ weak self ] time in
            guard let self = self else { return }
            
            self.ui.stopVideo()
            self.viewModel?.saveEpisodeTime(episodeId: self.currentEpisode.episodeId, time: time)
            self.viewModel?.backToGoLastScreen()
        }
        
        self.viewModel?.currentEpisodeTime.subscribe(with: { [ weak self ] time in
            guard let self = self else { return }
            
            self.ui.setTimeVideo(time: time)
        })
    }
}
