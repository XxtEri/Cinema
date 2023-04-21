//
//  SignUpScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class SignUpScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let spacingStack: CGFloat = 16
        
        static let buttonCornerRadius: CGFloat = 4
        static let buttonsBorderWidth: CGFloat = 1
        
        static let authButtonEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        static let changeAuthScreenButtonEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        
        static let imageLogoTopInset: CGFloat = UIScreen.main.bounds.height * 3 / 100
        static let imageLogoLeadingInset: CGFloat = 86
        static let imageLogoTrailingInset: CGFloat = 82
        
        static let infoStackHorizontalInset: CGFloat = 16
        static let infoStackTopInset: CGFloat = -64
        
        static let authButtonLeadingInset: CGFloat = 17
        static let authButtonTrailingInset: CGFloat = 16
        static let authButtonTopInset: CGFloat = -156
        
        static let changeAuthScreenButtonLeadingInset: CGFloat = 17
        static let changeAuthScreenButtonTrailingInset: CGFloat = 16
        static let changeAuthScreenButtonTopInset: CGFloat = -16
        static let changeAuthScreenButtonBottomInset = 44
    }
    
    private lazy var imageLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoApplication")
        view.contentMode = .scaleAspectFit
            
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metrics.spacingStack
        
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
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
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
        view.layer.cornerRadius = Metrics.buttonCornerRadius
        view.layer.borderWidth = Metrics.buttonsBorderWidth
        view.setTitle("Зарегистрироваться", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = Metrics.authButtonEdgeInsets
            
        return view
    }()
        
    private lazy var changeAuthScreenButton: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = Metrics.changeAuthScreenButtonEdgeInsets
        view.layer.cornerRadius = Metrics.buttonCornerRadius
        view.layer.borderWidth = Metrics.buttonsBorderWidth
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("У меня уже есть аккаунт", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
            
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.color = .accentColorApplication
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    
    //- MARK: Public properties
    
    var changeScreenHandler: (() -> Void)?
    
    var signUpHandler: ((RegisterCredentialDTO) -> Void)?

    
    //- MARK: Inits
    
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


//- MARK: Private extensions

private extension SignUpScreenView {
    
    //- MARK: Setup
    
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
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.imageLogoTopInset)
            make.leading.equalToSuperview().inset(Metrics.imageLogoLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.imageLogoTrailingInset)
            make.bottom.equalTo(infoStack.snp.top).inset(-5)
        }
        
        infoStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.infoStackHorizontalInset)
            make.top.lessThanOrEqualTo(imageLogo.snp.bottom).inset(-44)
            make.bottom.equalTo(authButton.snp.top).inset(-23)
        }
        
        authButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.authButtonLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.authButtonTrailingInset)
            make.top.greaterThanOrEqualTo(infoStack.snp.bottom).inset(-20)
        }
        
        changeAuthScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.changeAuthScreenButtonLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.changeAuthScreenButtonTrailingInset)
            make.top.equalTo(authButton.snp.bottom).inset(Metrics.changeAuthScreenButtonTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.changeAuthScreenButtonBottomInset)
        }
    }
    
    func configureAction() {
        changeAuthScreenButton.addTarget(self, action: #selector(changeScreen(_:)), for: .touchDown)
        
        authButton.addTarget(self, action: #selector(signUp(_:)), for: .touchDown)
    }
    
    
    //- MARK: Actions
    
    @objc
    func changeScreen(_ selector: AnyObject) {
        self.changeScreenHandler?()
    }
                             
    @objc
    func signUp(_ selector: AnyObject) {
        let user = RegisterCredentialDTO(firstName: firstNameInputField.text ?? String(),
                                         lastName: lastNameInputField.text ?? String(),
                                         email: emailInputField.text ?? String(),
                                         password: passwordInputField.text ?? String(),
                                         confirmPassword: confirmPasswordInputField.text ?? String())
        
        self.signUpHandler?(user)
    }
    
    @objc
        func textFieldDidChange(sender: UITextField) {
            sender.text = sender.text?.lowercased()
        }

}
