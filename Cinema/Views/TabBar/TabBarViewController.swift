//
//  TabBarViewController.swift
//  Cinema
//
//  Created by Елена on 02.04.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarAppearance()
    }
    
    func generateTabBar(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    private func setTabBarAppearance() {
        self.view.tintColor = .tabBarItemAccent
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }

}
