//
//  IconSelectionScreenView.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit
import SnapKit

class IconSelectionScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textSize: CGFloat = 17
        static let textKern: CGFloat = -0.41
        
        static let viewCornerRaduis: CGFloat = 10
        
        static let headViewHeight: CGFloat = 56
        
        static let titleScreenLeadingInset: CGFloat = 16
        static let titleScreenVerticalInset: CGFloat = 17
        
        static let backToGoCreateCollectionVerticalInset: CGFloat = 16
        static let backToGoCreateCollectionLeadingInset: CGFloat = 2
        static let backToGoCreateCollectionTrailingInset: CGFloat = 16
        
        static let collectionIconHorizontalInset: CGFloat = 16
        static let collectionIconTopInset: CGFloat = -16
    }
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = .iconSelectionScreenHeadBackground
        
        return view
    }()
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.textSize)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Выбрать иконку", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private let backToGoCreateCollection: UIButton = {
        let view = UIButton()
        view.setTitle("Отмена", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.attributedText = NSAttributedString(string: "Отмена", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private let collectionIcon: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .backgroundApplication
        view.showsVerticalScrollIndicator = false
        
        view.register(IconSelectionScreenCollectionViewCell.self, forCellWithReuseIdentifier: IconSelectionScreenCollectionViewCell.reuseIdentifier)
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    var closeSheetScreenButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(headView)
        
        headView.addSubview(titleScreen)
        headView.addSubview(backToGoCreateCollection)
        
        self.addSubview(collectionIcon)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureCollection(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionIcon.delegate = delegate
        collectionIcon.dataSource = dataSource
    }
    
    func reloadData() {
        collectionIcon.reloadData()
    }
}


//- MARK: Private extensions

private extension IconSelectionScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
        self.layer.cornerRadius = Metrics.viewCornerRaduis
        self.layer.masksToBounds = true
    }
    
    func configureConstraints() {
        headView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Metrics.headViewHeight)
        }
        
        titleScreen.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(Metrics.titleScreenLeadingInset)
            make.verticalEdges.equalToSuperview().inset(Metrics.titleScreenVerticalInset)
        }
        
        backToGoCreateCollection.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Metrics.backToGoCreateCollectionVerticalInset)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(Metrics.backToGoCreateCollectionLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.backToGoCreateCollectionTrailingInset)
            make.centerY.equalTo(titleScreen.snp.centerY)
        }
        
        collectionIcon.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.collectionIconHorizontalInset)
            make.top.equalTo(headView.snp.bottom).inset(Metrics.collectionIconTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureActions() {
        backToGoCreateCollection.addTarget(self, action: #selector(closeSheetScreen), for: .touchUpInside)
    }
    
    
    //- MARK: Actions
    
    @objc
    func closeSheetScreen() {
        closeSheetScreenButtonPressed?()
    }
}
