//
//  CreateCollectionsScreenViewController.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit

class CreateEditingCollectionsScreenViewController: UIViewController {
    
    private var ui: CreateEditingCollectionsScreenView
    var viewModel: CollectionScreenViewModel?
    
    init(isCreatingCollection: Bool) {
        self.ui = CreateEditingCollectionsScreenView()
        self.ui.isCreatingCollection = isCreatingCollection
        
        super.init(nibName: nil, bundle: nil)
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
    }

}

extension CreateEditingCollectionsScreenViewController {
    func handler() {
        self.ui.chooseIconCollectionButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToIconSelectionScreen()
        }
        
        self.ui.saveCollectionButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
        }

        self.ui.deleteCollectionButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
        }

        self.ui.backToGoCollectionsScreenButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToCollectionsScreen()
        }
    }
}
