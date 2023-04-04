//
//  SignUpScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

final class SignUpScreenView: UIView {
    
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
        view.backgroundColor = .accentColorApplication
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
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("У меня уже есть аккаунт", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
            
        return view
    }()
    
    var changeScreenHandler: (() -> Void)?
    
    var signUpHandler: ((RegisterCredential) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageLogo)
        self.addSubview(infoStack)
        self.addSubview(authButton)
        self.addSubview(changeAuthScreenButton)
        
        infoStack.addArrangedSubview(firstNameInputField)
        infoStack.addArrangedSubview(lastNameInputField)
        infoStack.addArrangedSubview(emailInputField)
        infoStack.addArrangedSubview(passwordInputField)
        infoStack.addArrangedSubview(confirmPasswordInputField)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SignUpScreenView {
    func setup() {
        configureUIView()
        configureConstraints()
        configureAction()
    }
    
    func configureUIView() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        imageLogo.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(UIScreen.main.bounds.height * 3 / 100)
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
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(44)
        }
    }
    
    func configureAction() {
        changeAuthScreenButton.addTarget(self, action: #selector(changeScreen(_:)), for: .touchDown)
        
        authButton.addTarget(self, action: #selector(signUp(_:)), for: .touchDown)
    }
    
    @objc
    func changeScreen(_ selector: AnyObject) {
        self.changeScreenHandler?()
    }
                             
    @objc
    func signUp(_ selector: AnyObject) {
        let user = RegisterCredential(firstName: firstNameInputField.text!, lastName: lastNameInputField.text!, email: emailInputField.text!, password: passwordInputField.text!)
        
        self.signUpHandler?(user)
    }
}
