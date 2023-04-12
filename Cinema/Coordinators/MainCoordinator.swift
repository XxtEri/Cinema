//
//  MainCoordinator.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

import UIKit

final class MainCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
    
    func goToEpisodeScreen(movie: Movie, episode: Episode) {
        let vc = EpisodeScreenViewController(movie: movie, episode: episode)
        vc.viewModel = MainViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToAuthorizationScreen() {
        let appc = parentCoordinator as? HomeCoordinator
        
        appc?.goToAuthScreen()
        appc?.childDidFinish(self)
    }
    
}
