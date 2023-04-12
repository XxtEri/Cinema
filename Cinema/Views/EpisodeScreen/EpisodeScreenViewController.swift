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
    
    var episode: Episode

    init(movie: Movie, episode: Episode) {
        self.ui = EpisodeScreenView()
        self.movie = movie
        self.episode = episode

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

        self.ui.configureUIData(movie: movie, episode: episode)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.ui.videoPlayerView.player?.play()
    }

    override func viewDidLayoutSubviews() {
        self.ui.videoPlayerView.playerLayer?.frame = self.ui.videoPlayerView.videoView.bounds
    }
}
