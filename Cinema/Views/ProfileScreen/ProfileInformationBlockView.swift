//
//  ProfileInformationBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class ProfileInformationBlockView: UIView {
    
    lazy var avatarImage: CircleImageView = {
        let view = CircleImageView()
        view.image = UIImage(named: "ProfileAnonymous")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    lazy var name: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "Герасимчук Елена", attributes: [.kern: -0.17])
        
        return view
    }()
    
    lazy var email: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        view.textAlignment = .left
        view.textColor = .gray
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "asd@gmail.com", attributes: [.kern: -0.17])
        
        return view
    }()
    
    private lazy var buttonChange: UIButton = {
        let view = UIButton()
        view.setAttributedTitle(NSAttributedString(string: "Изменить", attributes: [.kern: -0.17]), for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        
        return view
    }()
    
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
    
}

private extension ProfileInformationBlockView {
    func setup() {
        configureConstraints()
    }

    func configureConstraints() {
        avatarImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalTo(84)
        }
        
        buttonChange.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(avatarImage.snp.horizontalEdges)
            make.bottom.equalToSuperview()
            make.top.equalTo(avatarImage.snp.bottom).inset(-8)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalTo(avatarImage.snp.trailing).inset(-16)
        }
        
        email.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).inset(-4)
            make.leading.equalTo(name.snp.leading)
        }
    }
}

