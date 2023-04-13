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
        print("Main coordinator start")
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
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToAuthScreen() {
        let appc = parentCoordinator as? AppCoordinator
        
        appc?.goToAuth()
        appc?.childDidFinish(self)
    }

}

private extension HomeCoordinator {
    func generateMainScreenController() -> UIViewController {
        let profileCoordinator = MainCoordinator(navigationController: navigationController)
        
        profileCoordinator.parentCoordinator = self
        children.append(profileCoordinator)
        
        profileCoordinator.start()
        
        return profileCoordinator.generateMainScreen()
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
        
        vc.tabBarItem.title = "Подборка"
        vc.tabBarItem.image = UIImage(named: "TabItemCompilationScreen")
        
        return vc
    }
    
    func generateProfileScreenController() -> UIViewController {
        let vc = ProfileScreenViewController()
//        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Главное"
        vc.tabBarItem.image = UIImage(named: "TabItemMainScreen")
        
        return vc
    }
}
