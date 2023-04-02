//
//  TabBarViewController.swift
//  Cinema
//
//  Created by Елена on 02.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(viewConroller: ViewController(), title: "Главное", image: UIImage(named: "TabItemMainScreen")),
            generateVC(viewConroller: ViewController(), title: "Подборка", image: UIImage(named: "TabItemCompilationScreen")),
            generateVC(viewConroller: ViewController(), title: "Коллекции", image: UIImage(named: "TabItemCollectionScreen")),
            generateVC(viewConroller: ViewController(), title: "Профиль", image: UIImage(named: "TabItemProfileScreen"))
        ]
    }
    
    private func generateVC(viewConroller: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewConroller.tabBarItem.title = title
        viewConroller.tabBarItem.image = image
        
        return viewConroller
    }
    
    private func setTabBarAppearance() {
        self.view.tintColor = .tabBarItemAccent
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
}
