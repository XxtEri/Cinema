//
//  CollectionScreenDetailView.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class CollectionScreenDetailView: UIView {

    private lazy var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: 20)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.41])
        
        return view
    }()
    
    private var backArrow: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    lazy var editImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "Edit")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()

    private lazy var collections: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(CollectionScreenDetailCollectionViewCell.self, forCellWithReuseIdentifier: CollectionScreenDetailCollectionViewCell.reuseIdentifier)

        view.isScrollEnabled = true
        view.backgroundColor = .backgroundApplication
        
        return view
    }()
    
    private var collection: CollectionList?
    
    var buttonEditCollectionPressed: ((CollectionList) -> Void)?
    var backToGoCollectionsScreenButtonPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backArrow)
        self.addSubview(titleScreen)
        self.addSubview(editImage)
        self.addSubview(collections)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleCollection(title: String) {
        titleScreen.text = title
    }
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        
        collections.delegate = delegate
        collections.dataSource = dataSource
    }
    
    func setCollection(collection: CollectionList) {
        self.collection = collection
        
        if collection.collectionName == "Избранное" {
            editImage.isHidden = true
        }
        
        configureTitleCollection(title: collection.collectionName)
    }
    
    func reloadData() {
        collections.reloadData()
    }
}

private extension CollectionScreenDetailView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        backArrow.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(23.5)
            make.leading.equalToSuperview().inset(8.5)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.width.equalTo(12)
            make.height.equalTo(20.5)
        }
        
        titleScreen.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23.5)
            make.leading.greaterThanOrEqualTo(backArrow.snp.trailing).inset(-20)
            make.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        editImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(20)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.height.width.equalTo(16)
        }
        
        collections.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17.99)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleScreen.snp.bottom).inset(-55.99)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    func configureActions() {
        editImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedEditImage)))
        backArrow.addTarget(self, action: #selector(backToGoCollectionsScreen), for: .touchUpInside)
    }
    
    @objc
    func pressedEditImage() {
        if let currentCollection = collection {
            self.buttonEditCollectionPressed?(currentCollection)
        }
    }
    
    @objc
    func backToGoCollectionsScreen() {
        backToGoCollectionsScreenButtonPressed?()
    }
}
