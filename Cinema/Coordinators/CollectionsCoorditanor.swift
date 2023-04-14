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
    
    func generateCollectionsScreen() -> UIViewController {
        let vc = CollectionsScreenViewController()
        vc.viewModel = CollectionScreenViewModel(navigation: self)
        
        vc.tabBarItem.title = "Коллекции"
        vc.tabBarItem.image = UIImage(named: "TabItemCollectionScreen")
        
        return vc
    }
}

extension CollectionsCoorditanor: CollectionsNavigation {
    func goToCreateEditingCollectionScreen(isCreatingCollection: Bool, titleCollection: String?) {
        let vc = CreateEditingCollectionsScreenViewController(isCreatingCollection: isCreatingCollection, titleCollection: titleCollection)
        vc.viewModel = CollectionScreenViewModel(navigation: self)
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToIconSelectionScreen(delegate: SheetViewControllerDelegate) {
        let vc = IconSelectionScreenViewController()
        vc.viewModel = CollectionScreenViewModel(navigation: self)
        vc.delegate = delegate
        
        navigationController.present(vc, animated: true)
    }
    
    func backGoToCreateEditingCollectionScreen() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func goToCollectionsScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func goToCollectionScreenDetail(titleCollection: String) {
        let vc = CollectionScreenDetailViewController(titleCollection: titleCollection)
        vc.viewModel = CollectionScreenViewModel(navigation: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
