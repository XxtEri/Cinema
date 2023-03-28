//
//  SignUpViewController.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit
import SnapKit

class SingUpViewController: UIViewController {
    
    var viewModel: SignUpViewModel?
    
    private lazy var imageLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoApplication")
        view.contentMode = .scaleAspectFit
            
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        
        return view
    }()

    private lazy var firstNameInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Имя", isSecured: false)
            
        return view
    }()
    
    private lazy var lastNameInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Фамилия", isSecured: false)
            
        return view
    }()
    
    private lazy var emailInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "E-mail", isSecured: false)
            
        return view
    }()
        
    private lazy var passwordInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Пароль", isSecured: false)

        return view
    }()
    
    private lazy var confirmPasswordInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Повторите пароль", isSecured: false)

        return view
    }()
        
    private lazy var authButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "AccentColor")
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.setTitle("Зарегистрироваться", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
            
        return view
    }()
        
    private lazy var changeAuthScreenButton: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        view.setTitle("У меня уже есть аккаунт", for: .normal)
        view.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
            
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imageLogo)
        self.view.addSubview(infoStack)
        self.view.addSubview(authButton)
        self.view.addSubview(changeAuthScreenButton)
        
        infoStack.addArrangedSubview(firstNameInputField)
        infoStack.addArrangedSubview(lastNameInputField)
        infoStack.addArrangedSubview(emailInputField)
        infoStack.addArrangedSubview(passwordInputField)
        infoStack.addArrangedSubview(confirmPasswordInputField)
                
        self.setup()

    }
}

private extension SingUpViewController {
    func setup() {
        configureUIView()
        configureConstraints()
        configureAction()
    }
    
    func configureUIView() {
        self.view.backgroundColor = UIColor(named: "BackgroundApplication")
    }
    
    func configureConstraints() {
        imageLogo.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(UIScreen.main.bounds.height * 3 / 100)
            make.leading.equalToSuperview().inset(86)
            make.trailing.equalToSuperview().inset(82)
        }
        
        infoStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(imageLogo.snp.bottom).inset(-64)
        }
        
        authButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(16)
            make.top.lessThanOrEqualTo(infoStack.snp.bottom).inset(-156)
        }
        
        changeAuthScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(authButton.snp.bottom).inset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(44)
        }
    }
    
    func configureAction() {
        
    }
}
