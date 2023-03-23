//
//  SignUpViewViewController.swift
//  Cinema
//
//  Created by Елена on 22.03.2023.
//

import UIKit

class SignUpViewViewController: UIViewController {
    
    let ui: SingUpScreenView
    
    init() {
        self.ui = SingUpScreenView(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

