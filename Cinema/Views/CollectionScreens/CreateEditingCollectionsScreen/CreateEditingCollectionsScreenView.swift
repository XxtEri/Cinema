//
//  CreateCollectionsScreenView.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit
import SnapKit

class CreateEditingCollectionsScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textSize: CGFloat = 17
        static let textKern: CGFloat = -0.41
        
        static let buttonChooseIconCollectionEdgeInset = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        static let buttonChooseIconCollectionCornerRadius: CGFloat = 4
        static let buttonChooseIconCollectionBorderWidth: CGFloat = 1
        
        static let buttonSaveCollectionEdgeInset = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15)
        static let buttonSaveCollectionCornerRadius: CGFloat = 4
        static let buttonSaveCollectionBorderWidth: CGFloat = 1
        
        static let buttonDeleteCollectionEdgeInset = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        static let buttonDeleteCollectionCornerRadius: CGFloat = 4
        static let buttonDeleteCollectionBorderWidth: CGFloat = 1
        static let buttonDeleteCollectionOpacity: Float = 0
        
        static let backArrowLeadingInset: CGFloat = 8.5
        static let backArrowWidth: CGFloat = 12
        static let backArrowHeight: CGFloat = 20.5
        
        static let titleScreenTopInset: CGFloat = 23.5
        static let titleScreenLeadingInset: CGFloat = -16
        static let titleScreenTrailingInset: CGFloat = 16
        
        static let titleCollectionHorizontalinset: CGFloat = 16
        static let titleCollectionTopInset: CGFloat = -44
        
        static let iconCollectionLeadingInset: CGFloat = 16
        static let iconCollectionTopInset: CGFloat = -32
        static let iconCollectionHeightWidth: CGFloat = 72
        
        static let buttonChooseIconCollectionLeadingInset: CGFloat = 24
        static let buttonChooseIconCollectionTrailingInset: CGFloat = 22
        
        static let buttonSaveCollectionTopInset: CGFloat = -44
        static let buttonSaveCollectionHorizontalInset: CGFloat = 16
        
        static let buttonDeleteCollectionHorizontalInset: CGFloat = 16
        static let buttonDeleteCollectionTopInset: CGFloat = -16
    }
    
    private var backArrow: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    private var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: Metrics.textSize)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Создать коллекцию", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private var titleCollection: UICustomTextField = {
        var view = UICustomTextField()
        view = view.getCustomTextField(placeholder: "Название", isSecured: false)
        
        return view
    }()
    
    private var iconCollection: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private var buttonChooseIconCollection: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = Metrics.buttonChooseIconCollectionEdgeInset
        view.layer.cornerRadius = Metrics.buttonChooseIconCollectionCornerRadius
        view.layer.borderWidth = Metrics.buttonChooseIconCollectionBorderWidth
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("Выбрать иконку", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        
        return view
    }()
    
    private var buttonSaveCollection: UIButton = {
        let view = UIButton()
        view.backgroundColor = .accentColorApplication
        view.layer.cornerRadius = Metrics.buttonSaveCollectionCornerRadius
        view.layer.borderWidth = Metrics.buttonSaveCollectionBorderWidth
        view.setTitle("Сохранить", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = Metrics.buttonSaveCollectionEdgeInset
        
        return view
    }()
    
    private var buttonDeleteCollection: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = Metrics.buttonDeleteCollectionEdgeInset
        view.layer.cornerRadius = Metrics.buttonDeleteCollectionCornerRadius
        view.layer.borderWidth = Metrics.buttonDeleteCollectionBorderWidth
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("Удалить", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.layer.opacity = Metrics.buttonDeleteCollectionOpacity
        
        return view
    }()
    
    private var selectedImageName: String?
    private var collection: CollectionList?
    
    
    //- MARK: Public properties
    
    var isCreatingCollection: Bool = true
    
    var chooseIconCollectionButtonPressed: (() -> Void)?
    var saveCollectionButtonPressed: ((String, String) -> Void)?
    var updateCollectionButtonPressed: ((Collection, String) -> Void)?
    var deleteCollectionButtonPressed: ((String) -> Void)?
    var backToGoCollectionsScreenButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backArrow)
        self.addSubview(titleScreen)
        self.addSubview(titleCollection)
        self.addSubview(iconCollection)
        self.addSubview(buttonChooseIconCollection)
        self.addSubview(buttonSaveCollection)
        self.addSubview(buttonDeleteCollection)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func setCollection(collection: CollectionList) {
        self.collection = collection
    }
    
    func updateIconImage(imageName: String) {
        selectedImageName = imageName
        iconCollection.image = UIImage(named: imageName)
    }
    
    func setTitleCollection(titleCollection: String) {
        self.titleCollection.text = titleCollection
    }
    
    func updateUI() {
        if !isCreatingCollection {
            buttonDeleteCollection.layer.opacity = 1
            titleScreen.text = "Изменить коллекцию"
            
        } else {
            buttonDeleteCollection.layer.opacity = 0
            titleScreen.text = "Создать коллекцию"
        }
    }
}


//- MARK: Private extensions

private extension CreateEditingCollectionsScreenView {
    
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
        
        titleCollection.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.titleCollectionHorizontalinset)
            make.top.equalTo(titleScreen.snp.bottom).inset(Metrics.titleCollectionTopInset)
        }
        
        iconCollection.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.iconCollectionLeadingInset)
            make.top.equalTo(titleCollection.snp.bottom).inset(Metrics.iconCollectionTopInset)
            make.height.width.equalTo(Metrics.iconCollectionHeightWidth)
        }

        buttonChooseIconCollection.snp.makeConstraints { make in
            make.top.equalTo(iconCollection.snp.top)
            make.leading.equalTo(iconCollection.snp.trailing).inset(Metrics.buttonChooseIconCollectionLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.buttonChooseIconCollectionTrailingInset)
            make.centerY.equalTo(iconCollection.snp.centerY)
        }

        buttonSaveCollection.snp.makeConstraints { make in
            make.top.equalTo(iconCollection.snp.bottom).inset(Metrics.buttonSaveCollectionTopInset)
            make.horizontalEdges.equalToSuperview().inset(Metrics.buttonSaveCollectionHorizontalInset)
        }

        buttonDeleteCollection.snp.makeConstraints { make in
            make.top.equalTo(buttonSaveCollection.snp.bottom).inset(Metrics.buttonDeleteCollectionTopInset)
            make.horizontalEdges.equalToSuperview().inset(Metrics.buttonDeleteCollectionHorizontalInset)
        }
    }
    
    func configureActions() {
        buttonChooseIconCollection.addTarget(self, action: #selector(chooseIconCollection), for: .touchUpInside)
        buttonSaveCollection.addTarget(self, action: #selector(saveCollection), for: .touchUpInside)
        buttonDeleteCollection.addTarget(self, action: #selector(deleteCollection), for: .touchUpInside)
        backArrow.addTarget(self, action: #selector(backToGoCollectionsScreen), for: .touchUpInside)
    }
    
    
    //- MARK: Actions
    
    @objc
    func chooseIconCollection() {
        chooseIconCollectionButtonPressed?()
    }
    
    @objc
    func saveCollection() {
        if isCreatingCollection {
            if let titleCollection = titleCollection.text, let imageName = selectedImageName {
                saveCollectionButtonPressed?(titleCollection, imageName)
            }
            
        } else {
            if let collectionList = collection {
                if let title = titleCollection.text {
                    let oldCollection = Collection(collectionId: collectionList.collectionId, name: title)
                    updateCollectionButtonPressed?(oldCollection, selectedImageName ?? "Group 33")
                }
            }
        }
    }
    
    @objc
    func deleteCollection() {
        if let collectionId = collection?.collectionId {
            deleteCollectionButtonPressed?(collectionId)
        }
    }
    
    @objc
    func backToGoCollectionsScreen() {
        backToGoCollectionsScreenButtonPressed?()
    }
}
