//
//  CollectionsScreenView.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit
import SnapKit

class CollectionsScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textSize: CGFloat = 20
        static let textKern: CGFloat = -0.41
        
        static let titleScreenTopInset: CGFloat = 23
        
        static let plusImageTrailingInset: CGFloat = 22
        static let plusImageLeadingInset: CGFloat = 71
        static let plusImageHeightWidth: CGFloat = 16
        
        static let collectionsLeadingInset: CGFloat = 17.99
        static let collectionsTrailingInset: CGFloat = 16
        static let collectionsTopInset: CGFloat = -55.99
        static let collectionsBottomInset: CGFloat = 10
    }
    
    private lazy var collections: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.register(ProfileScreenCollectionViewCell.self, forCellWithReuseIdentifier: ProfileScreenCollectionViewCell.reuseIdentifier)

        view.isScrollEnabled = true
        view.backgroundColor = .backgroundApplication
        
        return view
    }()
    
    private lazy var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.textSize)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Коллекции", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var plusImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "Plus")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    var buttonAddingNewCollectionPressed: (() -> Void)?
    
    
    //- MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleScreen)
        self.addSubview(plusImage)
        self.addSubview(collections)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        
        collections.delegate = delegate
        collections.dataSource = dataSource
    }
    
    func reloadData() {
        collections.reloadData()
    }
}


//- MARK: Private extensions

private extension CollectionsScreenView {
    
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
        titleScreen.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.titleScreenTopInset)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        plusImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.plusImageTrailingInset)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(Metrics.plusImageLeadingInset)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.height.width.equalTo(Metrics.plusImageHeightWidth)
        }
        
        collections.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.collectionsLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.collectionsTrailingInset)
            make.top.equalTo(titleScreen.snp.bottom).inset(Metrics.collectionsTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.collectionsBottomInset)
        }
    }
    
    func configureActions() {
        plusImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedPlusImage)))
    }
    
    
    //- MARK: Actions
    
    @objc
    func pressedPlusImage() {
        self.buttonAddingNewCollectionPressed?()
    }
}
