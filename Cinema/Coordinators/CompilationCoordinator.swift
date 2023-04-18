//
//  CompilationCoordinator.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

final class CompilationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Compilation coordinator start")
    }
}

extension CompilationCoordinator: CompilationNavigation {
    func generateCompilationScreen() -> UIViewController {
        let vc = CompilationScreenViewController()
        vc.viewModel = CompilationScreenViewModel(navigation: self)
        
        vc.tabBarItem.title = "Подборка"
        vc.tabBarItem.image = UIImage(named: "TabItemCompilationScreen")
        
        return vc
    }
}
