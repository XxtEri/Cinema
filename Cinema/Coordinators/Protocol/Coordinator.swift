//
//  Coordinator.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? {get set}
    var children: [Coordinator] {get set}
    var navigationController: UINavigationController { get set }
        
    func start()
}
