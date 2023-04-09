//
//  CollectionsCoorditanor.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

final class CollectionsCoorditanor: Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Collections coordinator start")
    }
}

extension CollectionsCoorditanor: CollectionsNavigation {
    func generateCollectionsScreen() -> UIViewController {
        let vc = CollectionsScreenViewController()
//        vc.viewModel = ProfileViewModel(navigation: self)
        
        vc.tabBarItem.title = "Коллекции"
        vc.tabBarItem.image = UIImage(named: "TabItemCollectionScreen")
        
        return vc
    }
}
