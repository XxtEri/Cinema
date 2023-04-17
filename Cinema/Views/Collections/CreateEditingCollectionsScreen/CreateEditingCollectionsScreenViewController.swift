//
//  CreateCollectionsScreenViewController.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit

class CreateEditingCollectionsScreenViewController: UIViewController, SheetViewControllerDelegate {
    
    private var ui: CreateEditingCollectionsScreenView
    var viewModel: CollectionScreenViewModel?
    
    var isCreatinCollection: Bool
    
    var iconsImageName: [String] = {
        var array = [String]()
        
        for numberIcon in 1...36 {
            array.append("Group \(numberIcon)")
        }
        
        return array
    }()

    init(isCreatingCollection: Bool, currentCollection: CollectionList?) {
        self.ui = CreateEditingCollectionsScreenView()
        self.ui.isCreatingCollection = isCreatingCollection
        self.isCreatinCollection = isCreatingCollection
        
        if let collection = currentCollection {
            self.ui.setCollection(collection: collection)
        }
        
        if let title = currentCollection?.collectionName {
            self.ui.setTitleCollection(titleCollection: title)
        }
        
        if isCreatingCollection {
            self.ui.updateIconImage(imageName: iconsImageName[0])
            
        } else {
            if let imageName = currentCollection?.nameImageCollection {
                self.ui.updateIconImage(imageName: imageName)
            }
        }
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handler()
        setupToHideKeyboardOnTapOnView()
    }

    // Метод делегата для обработки переданных данных
    func didDismissSheetViewController(withData data: String) {
        self.ui.updateIconImage(imageName: data)
    }
}

extension CreateEditingCollectionsScreenViewController {
    func handler() {
        self.ui.chooseIconCollectionButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToIconSelectionScreen(delegate: self)
        }
        
        self.ui.backToGoCollectionsScreenButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToCollectionsScreen()
        }
        
        self.ui.saveCollectionButtonPressed = { [ weak self ] (titleCollection, imageName) in
            guard let self = self else { return }
            
            self.viewModel?.addNewCollection(collectionName: titleCollection, imageCollectionName: imageName)
        }
        
        self.ui.updateCollectionButtonPressed = { [ weak self ] (collection, imageCollectionName) in
            guard let self = self else { return }
            
            self.viewModel?.updateCollection(collection: collection, imageCollectionName: imageCollectionName)
        }

        self.ui.deleteCollectionButtonPressed = { [ weak self ] collectionId in
            guard let self = self else { return }
            
            self.viewModel?.deleteCollection(collectionId: collectionId)
        }
    }
}

private extension CreateEditingCollectionsScreenViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(sender:)))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
}
