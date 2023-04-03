//
//  SignUpViewController.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit
import SnapKit

class SingUpViewController: UIViewController {
    
    var viewModel: SignScreenViewModel?
    
    private var ui: SignUpScreenView
    
    init() {
        self.ui = SignUpScreenView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setHandlers() {
        self.ui.changeScreenHandler = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToSingIn()
        }
        
        self.ui.signUpHandler = { [ weak self ] user in
            guard let self = self else { return }
            
            self.viewModel?.signUp(user: user)
        }
    }
}
