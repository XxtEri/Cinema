//
//  SignUpViewViewController.swift
//  Cinema
//
//  Created by Елена on 22.03.2023.
//

import Foundation
import UIKit

final class SignInViewController: UIViewController {
    
    //- MARK: Private properties
    
    private let ui: SingInScreenView
    
    
    //- MARK: Public properties
    
    var viewModel: AuthViewModel?
    
    
    //- MARK: Inits
    
    init() {
        self.ui = SingInScreenView(frame: .zero)
        
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
        
        setHandlers()
        setupToHideKeyboardOnTapOnView()
    }
    
    
    //- MARK: Private methods

    private func showActivityIndicator() {
        self.ui.startAnumateIndicator()
    }
    
    private func hideActivityIndicator() {
        self.ui.stopAnimateIndicator()
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Внимание!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { action in }
        
        alertController.addAction(action)
        
        alertController.view.tintColor = .accentColorApplication
        
        self.present(alertController, animated: true, completion: nil)
    }
}


//- MARK: Private extensions

private extension SignInViewController {
    func setHandlers() {
        self.ui.changeScreenButtonTapHadler = { [weak self] in
            guard let self = self else { return }

            self.showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.viewModel?.goToSignUp()
            }
        }
        
        self.ui.authButtonTapHadler = { [ weak self ] in
            guard let self = self else { return }
            
            self.showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.viewModel?.signIn(userDTO: self.ui.getInforamtionInput())
            }
        }
        
        self.viewModel?.isNotValidData = { [ weak self ] result, nameScreen in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            
            if nameScreen == "signIn"{
                self.showError(result.rawValue)
            }
        }
        
        self.viewModel?.errorReceivedFromServer = { [ weak self ] requestStatus in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            
            if requestStatus == RequestStatus.notAuthorized {
                self.showError("Неверный логин или пароль")
            }
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
