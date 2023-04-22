//
//  ProfileScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

final class ProfileScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let signOutButtonEdgeInset = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        static let signOutButtonCornerRadius: CGFloat = 4
        static let signOutButtonBorderWidth: CGFloat = 1
        
        static let textKern: CGFloat = -0.17
        static let textSize: CGFloat = 16
        
        static let profileInformationBlockHorizontalInset: CGFloat = 16
        static let profileInformationBlockTopInset: CGFloat = 28
        
        static let buttonsLeadingInset: CGFloat = 17.99
        static let buttonsTrailingInset: CGFloat = 16
        static let buttonsTopInset: CGFloat = -55.99
        static let buttonsHeight: CGFloat = 180
        
        static let signOutButtonHorizontalInset: CGFloat = 16
        static let signOutButtonTopInset: CGFloat = -52
    }

    private lazy var buttons: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ProfileScreenCollectionViewCell.self, forCellWithReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier)

        view.isScrollEnabled = false
        view.backgroundColor = .backgroundApplication
        
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = Metrics.signOutButtonEdgeInset
        view.layer.cornerRadius = Metrics.signOutButtonCornerRadius
        view.layer.borderWidth = Metrics.signOutButtonBorderWidth
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setAttributedTitle(NSAttributedString(string: "Выход", attributes: [.kern: Metrics.textKern]), for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
                
            return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.color = .accentColorApplication
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    
    //- MARK: Public properties
    
    let profileInformationBlock = ProfileInformationBlockView()
    
    var signOutButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileInformationBlock)
        self.addSubview(buttons)
        self.addSubview(signOutButton)
        self.addSubview(activityIndicator)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        
        buttons.delegate = delegate
        buttons.dataSource = dataSource
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

private extension ProfileScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        profileInformationBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.profileInformationBlockHorizontalInset)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.profileInformationBlockTopInset)
        }
        
        buttons.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.buttonsLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.buttonsTrailingInset)
            make.top.equalTo(profileInformationBlock.snp.bottom).inset(Metrics.buttonsTopInset)
            make.height.lessThanOrEqualTo(Metrics.buttonsHeight)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.signOutButtonHorizontalInset)
            make.top.equalTo(buttons.snp.bottom).inset(Metrics.signOutButtonTopInset)
        }
    }
    
    func configureActions() {
        signOutButton.addTarget(self, action: #selector(signOut(sender:)), for: .touchDown)
    }
    
    
    //- MARK: Actions
    
    @objc
    func signOut(sender: AnyObject) {
        signOutButtonPressed?()
    }
}


//- MARK: Public extensions

extension ProfileScreenView {
    func set(with model: User) {
        self.profileInformationBlock.name.text = model.firstName + model.lastName
        self.profileInformationBlock.email.text = model.email
        
        if let link = model.avatar {
            self.profileInformationBlock.avatarImage.downloaded(from: link, contentMode: profileInformationBlock.avatarImage.contentMode)
        }
    }
}

