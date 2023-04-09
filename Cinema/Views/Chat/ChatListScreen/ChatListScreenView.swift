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
    
    private let collectionChats: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ChatListScreenCollectionViewCell.self, forCellWithReuseIdentifier: ChatListScreenCollectionViewCell.reuseIdentifier)
        
        view.backgroundColor = .backgroundApplication
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
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
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        titleScreen.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        collectionChats.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleScreen.snp.bottom).inset(-27)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
