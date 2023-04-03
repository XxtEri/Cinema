//
//  MainScreenViewController.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    
    //- MARK: Private properties
    
    private var ui: MainScreenView
    
    //- MARK: Initial
    
    init() {
        self.ui = MainScreenView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Lifecycle
    
    override func loadView() {
        self.view = ui
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


