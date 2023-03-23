//
//  SingUpScreenView.swift
//  Cinema
//
//  Created by Елена on 23.03.2023.
//

import UIKit
import SnapKit

class UICustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    func getCustomTextField(placeholder: String, isSecured: Bool) -> UICustomTextField {
        
        let view = UICustomTextField()
        view.textColor = UIColor(named: "GrayTextColor")
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.isSecureTextEntry = isSecured
        
        if let color = UIColor(named: "GrayTextColor") {
            view.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        return view
    }
}

class SingUpScreenView: UIView {
    lazy var imageLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoApplication")
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    lazy var emailInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "E-mail", isSecured: false)
        
        return view
    }()
    
    lazy var passwordInputField: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Пароль", isSecured: true)

        return view
    }()
    
    lazy var authButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "AccentColor")
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        
        return view
    }()
    
    lazy var changeAuthScreenButton: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        view.setTitle("Зарегестрироваться", for: .normal)
        view.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageLogo)
        self.addSubview(emailInputField)
        self.addSubview(passwordInputField)
        self.addSubview(authButton)
        self.addSubview(changeAuthScreenButton)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SingUpScreenView {
    func setup() {
        configureUIView()
        configureConstraints()
        configureAction()
    }
    
    func configureUIView() {
        self.backgroundColor = UIColor(named: "BackgroundApplication")
    }
    
    func configureConstraints() {
        imageLogo.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(100)
            make.leading.equalToSuperview().inset(86)
            make.trailing.equalToSuperview().inset(82)
        }
        
        emailInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(imageLogo.snp.bottom).inset(-104)
        }
        
        passwordInputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(emailInputField.snp.bottom).inset(-16)
        }
        
        authButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(16)
            make.top.lessThanOrEqualTo(passwordInputField.snp.bottom).inset(-156)
        }
        
        changeAuthScreenButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(authButton.snp.bottom).inset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(44)
        }
    }
    
    func configureAction() {
        
    }
}
