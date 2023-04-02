//
//  ProfileScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class ProfileScreenView: UIView {
    
    private let profileInformationBlock = ProfileInformationBlockView()

    private lazy var buttons: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ProfileScreenCollectionViewCell.self, forCellWithReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier)

        view.isScrollEnabled = false
        view.backgroundColor = .backgroundApplication
        
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setAttributedTitle(NSAttributedString(string: "Выход", attributes: [.kern: -0.17]), for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 16)
                
            return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileInformationBlock)
        self.addSubview(buttons)
        self.addSubview(signOutButton)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        
        buttons.delegate = delegate
        buttons.dataSource = dataSource
    }
}

private extension ProfileScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        profileInformationBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        buttons.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17.99)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(profileInformationBlock.snp.bottom).inset(-55.99)
            make.height.lessThanOrEqualTo(180)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(buttons.snp.bottom).inset(-52)
        }
    }
}

extension ProfileScreenView {
    func set(with model: User) {
        self.profileInformationBlock.name.text = model.firstName + model.lastName
        self.profileInformationBlock.email.text = model.email
        
        if let link = model.avatar {
            self.profileInformationBlock.avatarImage.downloaded(from: link)
        }
    }
}

