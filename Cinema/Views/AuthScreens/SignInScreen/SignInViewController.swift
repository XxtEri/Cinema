//
//  SignUpViewViewController.swift
//  Cinema
//
//  Created by Елена on 22.03.2023.
//

import UIKit

final class SignInViewController: UIViewController {
    
    var viewModel: SignViewModel?
    
    private let ui: SingInScreenView
    
    init() {
        self.ui = SingInScreenView(frame: .zero)
        
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
        
        setHandlers()
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
            
            self.viewModel?.signIn(userDTO: self.ui.getInforamtionInput())
        }
        
        self.viewModel?.isNotValidData = { [ weak self ] result, nameScreen in
            guard let self = self else { return }
            
            if nameScreen == "signIn"{
                self.showError(result.rawValue)
            }
        }
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Внимание!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { action in }
        
        alertController.addAction(action)
        
        alertController.view.tintColor = .accentColorApplication
        
        self.present(alertController, animated: true, completion: nil)
    }
}
