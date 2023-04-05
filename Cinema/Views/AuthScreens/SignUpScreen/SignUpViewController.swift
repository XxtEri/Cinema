//
//  SignUpViewController.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit
import SnapKit

final class SingUpViewController: UIViewController {
    
    var viewModel: SignViewModel?
    
    private var ui: SignUpScreenView
    
    init() {
        self.ui = SignUpScreenView()
        
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

        self.setHandlers()
    }
    
    private func setHandlers() {
        self.ui.changeScreenHandler = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToSingIn()
        }
        
        self.ui.signUpHandler = { [ weak self ] user in
            guard let self = self else { return }
            
            self.viewModel?.signUp(userDTO: user)
        }
        
        self.viewModel?.isNotValidData = { [ weak self ] result, nameScreen in
            guard let self = self else { return }
            
            if nameScreen == "signUp"{
                self.showError(result.rawValue)
            }
        }
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Внимание!", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { action in }
        
        alertController.addAction(action)
        alertController.addTextField(configurationHandler: nil)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
