//
//  ProfileInformationBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class ProfileInformationBlockView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textKern: CGFloat = -0.17
        
        static let nameTextSize: CGFloat = 24
        
        static let emailTextSize: CGFloat = 14
        
        static let buttonChangeTextSize: CGFloat = 14
        
        static let avatarImageSize: CGFloat = 84
        
        static let buttonChangeTopInset: CGFloat = -8
        
        static let nameLeadingInset: CGFloat = -16
        
        static let emailTopInset: CGFloat = -4
    }
    
    private lazy var buttonChange: UIButton = {
        let view = UIButton()
        view.setAttributedTitle(NSAttributedString(string: "Изменить", attributes: [.kern: Metrics.textKern]), for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Metrics.buttonChangeTextSize)
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    lazy var avatarImage: CircleImageView = {
        let view = CircleImageView()
        view.image = UIImage(named: "ProfileAnonymous")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var name: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.nameTextSize)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "Герасимчук Елена", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    lazy var email: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.emailTextSize)
        view.textAlignment = .left
        view.textColor = .gray
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "asd@gmail.com", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    var avatarChangeButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super .init(frame: frame)
            
        self.addSubview(avatarImage)
        self.addSubview(name)
        self.addSubview(email)
        self.addSubview(buttonChange)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func updateAvatar(image: UIImage) {
        avatarImage.image = image
    }
}


//- MARK: Private extensions

private extension ProfileInformationBlockView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureActions()
    }

    func configureConstraints() {
        avatarImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalTo(Metrics.avatarImageSize)
        }
        
        buttonChange.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(avatarImage.snp.horizontalEdges)
            make.bottom.equalToSuperview()
            make.top.equalTo(avatarImage.snp.bottom).inset(Metrics.buttonChangeTopInset)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalTo(avatarImage.snp.trailing).inset(Metrics.nameLeadingInset)
        }
        
        email.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).inset(Metrics.emailTopInset)
            make.leading.equalTo(name.snp.leading)
        }
    }
    
    func configureActions() {
        buttonChange.addTarget(self, action: #selector(changeAvatar(sender:)), for: .touchDown)
    }
    
    
    //- MARK: Actions
    
    @objc
    func changeAvatar(sender: AnyObject) {
        self.avatarChangeButtonPressed?()
    }
}

