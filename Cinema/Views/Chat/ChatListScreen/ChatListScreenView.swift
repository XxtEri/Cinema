//
//  DisscusionScreenView.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class ChatListScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleScreenTextSize: CGFloat = 17
        static let titleScreenTextKern: CGFloat = -0.41
        
        static let titleScreenTopInset: CGFloat = 23
        
        static let imageGoBackScreenTopInset: CGFloat = 23
        static let imageGoBackScreenLeadingInset: CGFloat = 8.5
        static let imageGoBackScreenTrailingInset: CGFloat = 40
        
        static let collectionChatsLeadinInset: CGFloat = 16
        static let collectionChatsTopInset: CGFloat = -27
        static let collectionChatsBottomInset: CGFloat = 10
    }
    
    private let titleScreen: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "Обсуждения", attributes: [.kern: Metrics.titleScreenTextKern])
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.titleScreenTextSize)
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
    
    
    //- MARK: Public properties
    
    var goBackButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits

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
    
    
    //- MARK: Public methods
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionChats.delegate = delegate
        collectionChats.dataSource = dataSource
    }
    
    func reloadData() {
        collectionChats.reloadData()
    }
}


//- MARK: Private extensions

private extension ChatListScreenView {
    
    //- MARK: Setup
    
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
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.titleScreenTopInset)
        }
        
        imageGoBackScreen.snp.makeConstraints { make in
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.imageGoBackScreenTopInset)
            make.leading.equalToSuperview().inset(Metrics.imageGoBackScreenLeadingInset)
            make.trailing.greaterThanOrEqualTo(titleScreen.snp.leading).inset(Metrics.imageGoBackScreenTrailingInset)
        }
        
        collectionChats.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.collectionChatsLeadinInset)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleScreen.snp.bottom).inset(Metrics.collectionChatsTopInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.collectionChatsBottomInset)
        }
    }
    
    func configureActions() {
        imageGoBackScreen.addTarget(self, action: #selector(goBack(sender:)), for: .touchDown)
    }
    
    
    //- MARK: Actions
    
    @objc
    func goBack(sender: AnyObject) {
       goBackButtonPressed?()
    }
}
