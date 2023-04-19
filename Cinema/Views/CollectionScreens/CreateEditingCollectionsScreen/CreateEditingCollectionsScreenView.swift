//
//  CreateCollectionsScreenView.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit
import SnapKit

class CreateEditingCollectionsScreenView: UIView {
    
    private var backArrow: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    private var titleScreen: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Semibold", size: 17)
        view.textAlignment = .center
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Создать коллекцию", attributes: [.kern: -0.41])
        
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
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("Выбрать иконку", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        
        return view
    }()
    
    private var buttonSaveCollection: UIButton = {
        let view = UIButton()
        view.backgroundColor = .accentColorApplication
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.setTitle("Сохранить", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15)
        
        return view
    }()
    
    private var buttonDeleteCollection: UIButton = {
        let view = UIButton()
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 13, right: 10)
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.borderButton.cgColor
        view.setTitle("Удалить", for: .normal)
        view.setTitleColor(.accentColorApplication, for: .normal)
        view.layer.opacity = 0
        
        return view
    }()
    
    private var selectedImageName: String?
    private var collection: CollectionList?
    
    var isCreatingCollection: Bool = true
    
    var chooseIconCollectionButtonPressed: (() -> Void)?
    var saveCollectionButtonPressed: ((String, String) -> Void)?
    var updateCollectionButtonPressed: ((Collection, String) -> Void)?
    var deleteCollectionButtonPressed: ((String) -> Void)?
    var backToGoCollectionsScreenButtonPressed: (() -> Void)?
    
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

extension CreateEditingCollectionsScreenView {
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
            make.leading.equalToSuperview().inset(8.5)
            make.centerY.equalTo(titleScreen.snp.centerY)
            make.width.equalTo(12)
            make.height.equalTo(20.5)
        }
        
        titleScreen.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(23.5)
            make.leading.greaterThanOrEqualTo(backArrow.snp.trailing).inset(-16)
            make.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        titleCollection.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleScreen.snp.bottom).inset(-44)
        }
        
        iconCollection.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleCollection.snp.bottom).inset(-32)
            make.height.width.equalTo(72)
        }

        buttonChooseIconCollection.snp.makeConstraints { make in
            make.top.equalTo(iconCollection.snp.top)
            make.leading.equalTo(iconCollection.snp.trailing).inset(-24)
            make.trailing.equalToSuperview().inset(22)
            make.centerY.equalTo(iconCollection.snp.centerY)
        }

        buttonSaveCollection.snp.makeConstraints { make in
            make.top.equalTo(iconCollection.snp.bottom).inset(-44)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        buttonDeleteCollection.snp.makeConstraints { make in
            make.top.equalTo(buttonSaveCollection.snp.bottom).inset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureActions() {
        buttonChooseIconCollection.addTarget(self, action: #selector(chooseIconCollection), for: .touchUpInside)
        buttonSaveCollection.addTarget(self, action: #selector(saveCollection), for: .touchUpInside)
        buttonDeleteCollection.addTarget(self, action: #selector(deleteCollection), for: .touchUpInside)
        backArrow.addTarget(self, action: #selector(backToGoCollectionsScreen), for: .touchUpInside)
    }
    
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
