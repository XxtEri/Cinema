//
//  MainScreenCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import KeychainSwift

final class MainCoordinator: Coordinator {
    private var keychain: KeychainSwift
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.keychain = KeychainSwift()
    }
    
    func start() {
        print("Main coordinator start")
    }
    
    func generateMainScreen() -> UIViewController {
        let vc = MainScreenViewController()
        vc.viewModel = MainViewModel(navigation: self)
        
        vc.tabBarItem.title = "Главное"
        vc.tabBarItem.image = UIImage(named: "TabItemMainScreen")
        
        return vc
    }
}

extension MainCoordinator: MainScreenNavigation {
    func goToMovieScreen(movie: Movie) {
        let vc = MovieScreenViewController(movie: movie)
        vc.viewModel = MainViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToEpisodeScreen(movie: Movie, currentEpisode: Episode, episodes: [Episode]) {
        let vc = EpisodeScreenViewController(movie: movie, currentEpisode: currentEpisode, episodes: episodes)
        vc.viewModel = MainViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func backToGoLastScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func goToAuthorizationScreen() {
        let appc = parentCoordinator as? HomeCoordinator
        
        keychain.synchronizable = true
        keychain.clear()
        
        appc?.goToAuthScreen()
        appc?.childDidFinish(self)
    }
    
}
