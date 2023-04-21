//
//  SingUpScreenView.swift
//  Cinema
//
//  Created by Елена on 23.03.2023.
//

import UIKit
import SnapKit

final class SingInScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let buttonCornerRadius: CGFloat = 4
        static let buttonsBorderWidth: CGFloat = 1
        
        static let authButtonEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        static let changeAuthScreenButtonEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        
        static let imageLogoTopInset: CGFloat = UIScreen.main.bounds.height * 3 / 100
        static let imageLogoLeadingInset: CGFloat = 86
        static let imageLogoTrailingInset: CGFloat = 82
        
        static let emailInputFieldHorizontalInset: CGFloat = 16
        static let emailInputFieldTopInset: CGFloat = -104
        
        static let passwordInputFieldHorizontalInset: CGFloat = 16
        static let passwordInputFieldTopInset: CGFloat = -16
        
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

    private lazy var emailInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "E-mail", isSecured: false)
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return view
    }()
    
    private lazy var passwordInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Пароль", isSecured: true)

        return view
    }()
    
    private lazy var authButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .accentColorApplication
        view.layer.cornerRadius = Metrics.buttonCornerRadius
        view.layer.borderWidth = Metrics.buttonsBorderWidth
        view.setTitle("Войти", for: .normal)
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
        view.setTitle("Зарегестрироваться", for: .normal)
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
    
    var changeScreenButtonTapHadler: (() -> Void)?
    var authButtonTapHadler: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageLogo)
        self.addSubview(emailInputField)
        self.addSubview(passwordInputField)
        self.addSubview(authButton)
        self.addSubview(changeAuthScreenButton)
        self.addSubview(activityIndicator)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func getInforamtionInput() -> LoginCredentialDTO {
        let user = LoginCredentialDTO(email: emailInputField.text ?? String(), password: passwordInputField.text ?? String())
        
        return user
    }
    
    func startAnumateIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
    }
    
    func stopAnimateIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }
}


//- MARK: Private extensions

private extension SingInScreenView {
    
    //  MARK: - Setup
    
    func setup() {
        configureUIView()
        configureConstraints()
        configureAction()
    }
    
    func configureUIView() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageLogo.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.imageLogoTopInset)
            make.leading.equalToSuperview().inset(Metrics.imageLogoLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.imageLogoTrailingInset)
        }
        
        emailInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.emailInputFieldHorizontalInset)
            make.top.equalTo(imageLogo.snp.bottom).inset(Metrics.emailInputFieldTopInset)
        }
        
        passwordInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.passwordInputFieldHorizontalInset)
            make.top.equalTo(emailInputField.snp.bottom).inset(Metrics.passwordInputFieldTopInset)
        }
        
        authButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.authButtonLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.authButtonTrailingInset)
            make.top.lessThanOrEqualTo(passwordInputField.snp.bottom).inset(Metrics.authButtonTopInset)
        }
        
        changeAuthScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.changeAuthScreenButtonLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.changeAuthScreenButtonTrailingInset)
            make.top.equalTo(authButton.snp.bottom).inset(Metrics.changeAuthScreenButtonTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.changeAuthScreenButtonBottomInset)
        }
    }
    
    func configureAction() {
        changeAuthScreenButton.addTarget(self, action: #selector(changeScreen(_:)), for: .allEvents)
        
        authButton.addTarget(self, action: #selector(signIn(_:)), for: .touchDown)
    }
    
    
    // MARK: - Actions
    
    @objc
    func changeScreen(_ selector: AnyObject) {
        self.changeScreenButtonTapHadler?()
    }
    
    @objc
    func signIn(_ selector: AnyObject) {
        self.authButtonTapHadler?()
    }
    
    @objc
        func textFieldDidChange(sender: UITextField) {
            sender.text = sender.text?.lowercased()
        }

}
