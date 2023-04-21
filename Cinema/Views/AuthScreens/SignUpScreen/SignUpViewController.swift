//
//  SignUpViewController.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit
import SnapKit

final class SingUpViewController: UIViewController {
    
    //- MARK: Private properties
    
    private var ui: SignUpScreenView
    
    //- MARK: Public properties
    
    var viewModel: AuthViewModel?
    
    //- MARK: Inits
    
    init() {
        self.ui = SignUpScreenView()
        
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

        self.setHandlers()
        self.setupToHideKeyboardOnTapOnView()
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


//- MARK: Private extenstions

private extension SingUpViewController {
    private func setHandlers() {
        self.ui.changeScreenHandler = { [ weak self ] in
            guard let self = self else { return }
            
            self.showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.viewModel?.goToSingIn()
            }
        }
        
        self.ui.signUpHandler = { [ weak self ] user in
            guard let self = self else { return }
            
            self.showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.viewModel?.signUp(userDTO: user)
            }
        }
        
        self.viewModel?.isNotValidData = { [ weak self ] result, nameScreen in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            
            if nameScreen == "signUp"{
                self.showError(result.rawValue)
            }
        }
        
        self.viewModel?.errorServer.subscribe(with: { [weak self] error in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            
            self.showError("Что-то пошло не так. Вероятно произошла ошибка на внутреннем сервере. Повторите попытку")
        })
    }
}

private extension SingUpViewController {
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
