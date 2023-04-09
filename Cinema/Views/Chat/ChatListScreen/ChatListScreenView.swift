//
//  DisscusionScreenView.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class ChatListScreenView: UIView {
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Обсуждения", attributes: [.kern: -0.41])
        view.font = UIFont(name: "SFProText-Semibold", size: 17)
        view.textColor = .white
        view.textAlignment = .center
        
        return view
    }()
    
    private let imageGoBackScreen: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    private let collectionChats: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ChatListScreenCollectionViewCell.self, forCellWithReuseIdentifier: ChatListScreenCollectionViewCell.reuseIdentifier)
        
        view.backgroundColor = .backgroundApplication
        
        return view
    }()
    
    var goBackButtonPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
        self.addSubview(imageGoBackScreen)
        self.addSubview(collectionChats)
        
        self.inputViewController?.navigationController?.title = "Title"
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionChats.delegate = delegate
        collectionChats.dataSource = dataSource
    }
}

private extension ChatListScreenView {
    func setup() {
        configureConstraints()
        configureUI()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        titleScreen.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23)
        }
        
        imageGoBackScreen.snp.makeConstraints { make in
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23)
            make.leading.equalToSuperview().inset(8.5)
            make.trailing.greaterThanOrEqualTo(titleScreen.snp.leading).inset(40)
        }
        
        collectionChats.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleScreen.snp.bottom).inset(-27)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    func configureActions() {
        imageGoBackScreen.addTarget(self, action: #selector(goBack(sender:)), for: .touchDown)
    }
    
    @objc
    func goBack(sender: AnyObject) {
       goBackButtonPressed?()
    }
}
