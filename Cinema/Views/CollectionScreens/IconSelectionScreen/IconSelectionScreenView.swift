//
//  IconSelectionScreenView.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit

class IconSelectionScreenView: UIView {
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = .iconSelectionScreenHeadBackground
        
        return view
    }()
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: 17)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Выбрать иконку", attributes: [.kern: -0.41])
        
        return view
    }()
    
    private let backToGoCreateCollection: UIButton = {
        let view = UIButton()
        view.setTitle("Отмена", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.attributedText = NSAttributedString(string: "Отмена", attributes: [.kern: -0.41])
        
        return view
    }()
    
    private let collectionIcon: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .backgroundApplication
        view.showsVerticalScrollIndicator = false
        
        view.register(IconSelectionScreenCollectionViewCell.self, forCellWithReuseIdentifier: IconSelectionScreenCollectionViewCell.reuseIdentifier)
        
        return view
    }()
    
    var closeSheetScreenButtonPressed: (() -> Void)?

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
    
    func configureCollection(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionIcon.delegate = delegate
        collectionIcon.dataSource = dataSource
    }
    
    func reloadData() {
        collectionIcon.reloadData()
    }
}

extension IconSelectionScreenView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func configureConstraints() {
        headView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }
        
        titleScreen.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(17)
        }
        
        backToGoCreateCollection.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(titleScreen.snp.trailing).inset(2)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleScreen.snp.centerY)
        }
        
        collectionIcon.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(headView.snp.bottom).inset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureActions() {
        backToGoCreateCollection.addTarget(self, action: #selector(closeSheetScreen), for: .touchUpInside)
    }
    
    @objc
    func closeSheetScreen() {
        closeSheetScreenButtonPressed?()
    }
}
