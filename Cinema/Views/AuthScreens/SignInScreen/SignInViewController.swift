//
//  SignUpViewViewController.swift
//  Cinema
//
//  Created by Елена on 22.03.2023.
//

import UIKit

class SignInViewController: UIViewController {
    
    var viewModel: SignViewModel?
    
    private let ui: SingInScreenView
    
    init() {
        self.ui = SingInScreenView(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
        
        setHandlers()
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

}

private extension SignInViewController {
    func setHandlers() {
        self.ui.changeScreenButtonTapHadler = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel?.goToSignUp()
        }
        
        self.ui.authButtonTapHadler = { [ weak self ] in
            guard let self = self else { return }
            
            let user = LoginCredential(email: "asd@gm.com", password: "asd123")
            
            self.viewModel?.signIn(user: user)
        }
    }
}
