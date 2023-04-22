//
//  CollectionScreenDetailView.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit
import SnapKit

class CollectionScreenDetailView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleScreenTextSize: CGFloat = 20
        static let titleScreenTextKern: CGFloat = -0.41
        
        static let backArrowTopInset: CGFloat = 23.5
        static let backArrowLeadingInset: CGFloat = 8.5
        static let backArrowWidth: CGFloat = 12
        static let backArrowHeight: CGFloat = 20.5
        
        static let titleScreenTopInset: CGFloat = 23.5
        static let titleScreenLeadingInset: CGFloat = -20
        static let titleScreenTrailingInset: CGFloat = 16
        
        static let editImageTrailingInset: CGFloat = 20
        static let editImageLeadingInset: CGFloat = 20
        static let editImageHeightWidth: CGFloat = 16
        
        static let collectionsLeadingInset: CGFloat = 17.99
        static let collectionsTrailingInset: CGFloat = 16
        static let collectionsTopInset: CGFloat = -55.99
        static let collectionsBottomInset: CGFloat = 10
    }

    private lazy var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.titleScreenTextSize)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.titleScreenTextKern])
        
        return view
    }()
    
    private lazy var backArrow: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    private lazy var editImage: UIImageView = {
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
    
    
    //- MARK: Public properties
    
    var buttonEditCollectionPressed: ((CollectionList) -> Void)?
    var backToGoCollectionsScreenButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits

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
    
    
    //- MARK: Private methods
    
    private func configureTitleCollection(title: String) {
        titleScreen.text = title
    }
    
    
    //- MARK: Public methods
    
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


//- MARK: Private extensions

private extension CollectionScreenDetailView {
    
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
        backArrow.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metrics.backArrowTopInset)
            make.leading.equalToSuperview().inset(Metrics.backArrowLeadingInset)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.width.equalTo(Metrics.backArrowWidth)
            make.height.equalTo(Metrics.backArrowHeight)
        }
        
        titleScreen.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.titleScreenTopInset)
            make.leading.greaterThanOrEqualTo(backArrow.snp.trailing).inset(Metrics.titleScreenLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.titleScreenTrailingInset)
            make.centerX.equalToSuperview()
        }
        
        editImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.editImageTrailingInset)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(Metrics.editImageLeadingInset)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.height.width.equalTo(Metrics.editImageHeightWidth)
        }
        
        collections.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.collectionsLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.collectionsTrailingInset)
            make.top.equalTo(titleScreen.snp.bottom).inset(Metrics.collectionsTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.collectionsBottomInset)
        }
    }
    
    func configureActions() {
        editImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedEditImage)))
        backArrow.addTarget(self, action: #selector(backToGoCollectionsScreen), for: .touchUpInside)
    }
    
    
    //- MARK: Actions
    
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
