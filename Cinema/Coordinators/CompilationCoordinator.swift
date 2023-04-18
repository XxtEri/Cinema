//
//  CompilationCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import KeychainSwift

final class CompilationCoordinator: Coordinator {
    private var keychain: KeychainSwift
    
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.keychain = KeychainSwift()
    }
    
    func start() {
        print("Compilation coordinator start")
    }
}

extension CompilationNavigation {
    func generateCompilationScreen() -> UIViewController {
        let vc = CompilationScreenViewController()
        vc.viewModel = CompilationScreenViewModel(navigation: self)
        
        vc.tabBarItem.title = "Подборка"
        vc.tabBarItem.image = UIImage(named: "TabItemCompilationScreen")
        
        return vc
    }
}

extension CompilationCoordinator: CompilationNavigation {
    func goToMovieScreen(movie: Movie) {
        let homeCoordinator = parentCoordinator as? HomeCoordinator
        
        homeCoordinator?.children.forEach({ coordinator in
            if let mainCoordinator = coordinator as? MainCoordinator {
                mainCoordinator.goToMovieScreen(movie: movie)
            }
        })
    }
    
    func goToAuthorizationScreen() {
        let homeCoordinator = parentCoordinator as? HomeCoordinator
        
        keychain.synchronizable = true
        keychain.clear()
        
        homeCoordinator?.goToAuthScreen()
        homeCoordinator?.childDidFinish(self)
    }
}
