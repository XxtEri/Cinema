//
//  ColelctionScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import KeychainSwift

class CollectionScreenViewModel {
    private let api: ApiRepository
    private let service: CollectionService
    
    weak var navigation: CollectionsNavigation?
    
    var selectedImage: String?
    var endChangeDatabase: (() -> Void)?
    
    var collections = Observable<Collection>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: CollectionsNavigation) {
        self.navigation = navigation
        self.service = CollectionService()
        self.api = ApiRepository()
    }
    
    func goToCreateEditingCollectionScreen(isCreatingCollection: Bool, titleCollection: String?) {
        navigation?.goToCreateEditingCollectionScreen(isCreatingCollection: isCreatingCollection, titleCollection: titleCollection)
    }
    
    func backGoToCreateEditingCollectionScreen() {
        navigation?.backGoToCreateEditingCollectionScreen()
    }
    
    func goToIconSelectionScreen(delegate: SheetViewControllerDelegate) {
        navigation?.goToIconSelectionScreen(delegate: delegate)
    }
    
    func goToCollectionsScreen() {
        navigation?.goToCollectionsScreen()
    }
    
    func goToCollectionScreenDetail(titleCollection: String) {
        navigation?.goToCollectionScreenDetail(titleCollection: titleCollection)
    }
}

private extension CollectionScreenViewModel {
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
}

extension CollectionScreenViewModel: ICollectionScreenViewModel {
    func addNewCollection(collectionName: String, imageCollectionName: String) {
        let collection = CollectionForm(name: collectionName)
        
        self.api.addNewCollection(collection: collection) { [ self ] result in
            switch result {
            case .success(let collection):
                let collectionDatabase = CollectionList()
                collectionDatabase.collectionName = collection.name
                collectionDatabase.collectionId = collection.collectionId
                collectionDatabase.nameImageCollection = imageCollectionName
                
                self.service.addNewCollection(collection: collectionDatabase) { [ self ] result in
                    switch result {
                    case .success(_):
                        endChangeDatabase?()
                    case .failure(let error):
                        failureLoadingHandle(with: error)
                    }
                }
    
            case .failure(let error):
                failureLoadingHandle(with: error)
                print(error.localizedDescription)
            }
        }
        
        self.goToCollectionsScreen()
    }
    
    func updateCollection() {
        
    }
    
    func deleteCollection() {
        
    }
}
