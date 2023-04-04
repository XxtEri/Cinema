//
//  MainCoordinator.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Home coordinator start")
        launchTabBar()
    }
    
    func launchTabBar() {
        let vc = TabBarViewController()
        let viewControllers = [
            generateMainScreenController(),
            generateCompilationScreenController(),
            generateCollectionScreenController(),
            generateProfileScreenController()
        ]
        
        vc.generateTabBar(viewControllers: viewControllers)
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
}

private extension HomeCoordinator {
    func generateMainScreenController() -> UIViewController {
        let vc = ProfileScreenViewController()
//        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Главное"
        vc.tabBarItem.image = UIImage(named: "TabItemMainScreen")
        
        return vc
    }
    
    func generateCompilationScreenController() -> UIViewController {
        let vc = ProfileScreenViewController()
//        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Подборка"
        vc.tabBarItem.image = UIImage(named: "TabItemCompilationScreen")
        
        return vc
    }
    
    func generateCollectionScreenController() -> UIViewController {
        let vc = ProfileScreenViewController()
//        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Коллекции"
        vc.tabBarItem.image = UIImage(named: "TabItemCollectionScreen")
        
        return vc
    }
    
    func generateProfileScreenController() -> UIViewController {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        
        profileCoordinator.parentCoordinator = self
        children.append(profileCoordinator)
        
        profileCoordinator.start()
        
        return profileCoordinator.generateProfileScreen()
    }
}

