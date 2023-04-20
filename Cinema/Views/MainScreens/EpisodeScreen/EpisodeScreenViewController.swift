//
//  EpisodeScreenViewController.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import RealmSwift

class EpisodeScreenViewController: UIViewController {

    private let ui: EpisodeScreenView
    
    var viewModel: MainViewModel?
    
    var movie: Movie
    
    var isFavoriteMovie: Bool?
    
    var currentEpisode: Episode
    
    var episodes: [Episode]
    
    var collections: Results<CollectionList>?

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
        bindListener()

        self.ui.configureUIData(movie: movie, episode: currentEpisode)
        self.ui.setYearsMovie(episodes: episodes)
        
        self.viewModel?.getEpisodeTime(episodeId: currentEpisode.episodeId)
        self.viewModel?.getMoviesIFavoriteCollection(currentMovieId: movie.movieId)
        self.viewModel?.getCollectionsUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        self.ui.videoPlayerView.playerLayer?.frame = self.ui.videoPlayerView.videoView.bounds
    }
    
    private func showActionSheet() {
        if collections == nil || collections?.count == 1 {
            self.showAlert(errorMessage: "У вас пока еще нет других коллекций, помимо коллекции для избранных фильмов")
        }
        
        let actionSheet = UIAlertController(title: "Добавить в коллекцию", message: nil, preferredStyle: .actionSheet)
        
        collections?.forEach({ collection in
            if collection.collectionName != "Избранное" {
                actionSheet.addAction(UIAlertAction(title: collection.collectionName, style: .destructive, handler: { action in
                    self.viewModel?.addToCollection(collectionId: collection.collectionId, movieId: self.movie.movieId)
                }))
            }
        })
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showAlert(errorMessage: String) {
        let alertController = UIAlertController(title: "Внимание!", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { action in }
        
        alertController.addAction(action)
        
        alertController.view.tintColor = .accentColorApplication
        
        self.present(alertController, animated: true, completion: nil)
    }
}

private extension EpisodeScreenViewController {
    func handler() {
        self.ui.buttonBackGoToLastScreenPressed = { [ weak self ] time in
            guard let self = self else { return }
            
            self.ui.stopVideo()
            self.viewModel?.saveEpisodeTime(episodeId: self.currentEpisode.episodeId, time: time)
            self.viewModel?.backToGoLastScreen()
        }
        
        self.ui.informationMovie.likeIconPressed = { [ weak self ] in
            guard let self = self else { return }
            
            if let checkInFavoriteCollection = self.isFavoriteMovie {
                if checkInFavoriteCollection {
                    self.viewModel?.deleteLikeToMovie(movieId: self.movie.movieId)
                    
                } else {
                    self.viewModel?.setLikeToMove(movieId: self.movie.movieId)
                }
            }
        }
        
        self.ui.informationMovie.chatIconPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToChatMovie(chatModel: self.movie.chatInfo)
        }
        
        self.ui.informationMovie.plusIconPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.showActionSheet()
        }
        
        self.viewModel?.addToFavoriteMovieSuccess = { [ weak self ] in
            guard let self = self else { return }
            
            self.isFavoriteMovie = true
            self.ui.informationMovie.updateLikeIcon(isFavoriteMovie: true)
        }
        
        self.viewModel?.deleteMovieInFavoriteMovieSuccess = { [ weak self ] in
            guard let self = self else { return }
            
            self.isFavoriteMovie = false
            self.ui.informationMovie.updateLikeIcon(isFavoriteMovie: false)
        }
    }
    
    func bindListener() {
        self.viewModel?.currentEpisodeTime.subscribe(with: { [ weak self ] time in
            guard let self = self else { return }
            
            self.ui.setTimeVideo(time: time)
        })
        
        self.viewModel?.moviesInFavoriteCollection.subscribe(with: { [ weak self ] favoriteMovies in
            guard let self = self else { return }
            
            self.isFavoriteMovie = false
            
            favoriteMovies.forEach { favoriteMovie in
                if favoriteMovie.movieId == self.movie.movieId {
                    self.isFavoriteMovie = true
                }
            }
            
            self.ui.informationMovie.updateLikeIcon(isFavoriteMovie: (self.isFavoriteMovie ?? false))
        })
        
        self.viewModel?.collectionsUser.subscribe(with: { [ weak self ] collectionsUser in
            guard let self = self else { return }
            
            self.collections = collectionsUser
        })
    }
}
