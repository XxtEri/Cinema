//
//  SignUpViewViewController.swift
//  Cinema
//
//  Created by Елена on 22.03.2023.
//

import UIKit

final class SignInViewController: UIViewController {
    
    var viewModel: SignScreenViewModel?
    
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
        
        self.setupToHideKeyboardOnTapOnView()
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
            
            self.viewModel?.signIn(user: self.ui.getInforamtionInput())
        }
    }
}

private extension SignInViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(sender:)))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
}
