//
//  CollectionsScreenView.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class CollectionsScreenView: UIView {
    
    lazy var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: 20)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Коллекции", attributes: [.kern: -0.41])
        
        return view
    }()
    
    lazy var addCollectionButton: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "AddCollection")
        view.contentMode = .scaleAspectFit
        
        return view
    }()

    private lazy var collections: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ProfileScreenCollectionViewCell.self, forCellWithReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier)

        view.isScrollEnabled = false
        view.backgroundColor = .backgroundApplication
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
        self.addSubview(addCollectionButton)
        self.addSubview(collections)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        
        collections.delegate = delegate
        collections.dataSource = dataSource
    }
}

private extension CollectionsScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        titleScreen.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        addCollectionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(22)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(71)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.height.width.equalTo(16)
        }
        
        collections.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17.99)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleScreen.snp.bottom).inset(-55.99)
            make.height.equalTo(56*2)
        }
    }
}
