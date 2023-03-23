//
//  SingUpScreenView.swift
//  Cinema
//
//  Created by Елена on 23.03.2023.
//

import UIKit
import SnapKit

class SingUpScreenView: UIView {
    lazy var imageLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LogoApplication")
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    lazy var emailInputField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "PlaceholderColor")!])
        view.textColor = .white
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, view.frame.height))
        view.leftView = paddingView
        
        return view
    }()
    
    lazy var passwordInputField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "PlaceholderColor")!])
        view.textColor = .white
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "PlaceholderColor")?.cgColor
        
        return view
    }()
    
    lazy var authButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor(named: "AccentColor")
        
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.white, for: .normal)
        
        
        return view
    }()
    
    lazy var changeAuthScreenButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.658, green: 0.658, blue: 0.658, alpha: 1).cgColor
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
