//
//  ChatScreenView.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class ChatScreenView: UIView {
    
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
    
    let chat: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuseIdentifier)
        
        view.register(MyMessageCollectionViewCell.self, forCellWithReuseIdentifier: MyMessageCollectionViewCell.reuseIdentifier)
        
        view.register(OtherMessageCollectionViewCell.self, forCellWithReuseIdentifier: OtherMessageCollectionViewCell.reuseIdentifier)
        
        view.backgroundColor = .backgroundApplication
        
        return view
    }()

    var goBackButtonPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
        self.addSubview(imageGoBackScreen)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollection(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        chat.delegate = delegate
        chat.dataSource = dataSource
    }
}

private extension ChatScreenView {
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
    }
    
    func configureActions() {
        imageGoBackScreen.addTarget(self, action: #selector(goBack(sender:)), for: .touchDown)
    }
    
    @objc
    func goBack(sender: AnyObject) {
       goBackButtonPressed?()
    }
}

