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
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        navigationController.viewControllers.removeAll()
        navigationController.setNavigationBarHidden(true, animated: false)
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
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        mainCoordinator.parentCoordinator = self
        children.append(mainCoordinator)
        
        mainCoordinator.start()
        
        return mainCoordinator.generateMainScreen()
    }
    
    func generateCompilationScreenController() -> UIViewController {
        let compilationCoordinator = CompilationCoordinator(navigationController: navigationController)
        
        compilationCoordinator.parentCoordinator = self
        children.append(compilationCoordinator)
        
        compilationCoordinator.start()
        
        return compilationCoordinator.generateCompilationScreen()
    }
    
    func generateCollectionScreenController() -> UIViewController {
        let collectionsCoordinator = CollectionsCoorditanor(navigationController: navigationController)
        
        collectionsCoordinator.parentCoordinator = self
        children.append(collectionsCoordinator)
        
        collectionsCoordinator.start()
        
        return collectionsCoordinator.generateCollectionsScreen()
    }
    
    func generateProfileScreenController() -> UIViewController {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        
        profileCoordinator.parentCoordinator = self
        children.append(profileCoordinator)
        
        profileCoordinator.start()
        
        return profileCoordinator.generateProfileScreen()
    }
}
