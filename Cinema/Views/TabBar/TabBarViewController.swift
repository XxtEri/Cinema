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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBar.insetsLayoutMarginsFromSafeArea = true
        self.tabBar.layoutMargins = UIEdgeInsets(top: 11.33, left: 0, bottom: 4.8, right: 0)
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
