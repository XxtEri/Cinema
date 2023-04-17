//
//  CollectionScreenDetailViewController.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class CollectionScreenDetailViewController: UIViewController {
    
    private let ui: CollectionScreenDetailView
    var viewModel: CollectionScreenViewModel?
    
    init(collection: CollectionList) {
        self.ui = CollectionScreenDetailView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.ui.setCollection(collection: collection)
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

extension CollectionScreenDetailViewController {
    func handler() {
        self.ui.backToGoCollectionsScreenButtonPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.viewModel?.goToCollectionsScreen()
        }
        
        self.ui.buttonEditCollectionPressed = { [ weak self ] collection in
            guard let self = self else { return }
            
            self.viewModel?.goToCreateEditingCollectionScreen(isCreatingCollection: false, collection: collection)
        }
    }
}
