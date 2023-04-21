//
//  TabBarViewController.swift
//  Cinema
//
//  Created by Елена on 02.04.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    //- MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarAppearance()
    }
    
    
    //- MARK: Private methods
    
    private func setTabBarAppearance() {
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .tabBarBackgroundColor
        self.tabBar.backgroundColor = .tabBarBackgroundColor
        self.tabBar.tintColor = .tabBarItemAccent
        self.tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
    
    //- MARK: Public methods
    
    func generateTabBar(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
