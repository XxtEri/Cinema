//
//  ColelctionScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import KeychainSwift
import RealmSwift

class CollectionScreenViewModel {
    private let api: ApiRepository
    private var validation: ValidationCollectionScreen
    private let service: CollectionService
    
    weak var navigation: CollectionsNavigation?

    var isCreatingAnotherFavoritesCollection: (() -> Void)?
    var isNotValidData: ((String) -> Void)?
    
    var collection = Observable<Collection>()
    var collectionsDatabase = Observable<Results<CollectionList>>()
    var moviesCollection = Observable<[Movie]>()
    var errorOnLoading = Observable<Error>()
    
    init(navigation: CollectionsNavigation) {
        self.navigation = navigation
        self.service = CollectionService()
        self.api = ApiRepository()
        self.validation = ValidationCollectionScreen()
    }
    
    func goToCreateEditingCollectionScreen(isCreatingCollection: Bool, collection: CollectionList?) {
        navigation?.goToCreateEditingCollectionScreen(isCreatingCollection: isCreatingCollection, collection: collection)
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
    
    func goToLastScreen() {
        navigation?.goToLastScreen()
    }
    
    func goToCollectionScreenDetail(collection: CollectionList) {
        navigation?.goToCollectionScreenDetail(collection: collection)
    }
    
    func goToMovieScreen(movie: Movie) {
        navigation?.goToMovieScreen(movie: movie)
    }
}

private extension CollectionScreenViewModel {
    func successLoadingHandle(with model: [Collection]) {
        let defaultImageCollectionName = "Group 33"
        let imageNameForFavoriteCollection = "Group 1"
        
        
        model.forEach { collection in
            if !self.service.checkEntityExistsInRealm(collectionId: collection.collectionId) {
                if collection.name == "Избранное" {
                    addCollectionToDatabase(with: collection, imageCollectionName: imageNameForFavoriteCollection)
                    
                } else {
                    addCollectionToDatabase(with: collection, imageCollectionName: defaultImageCollectionName)
                }
            }
        }
        
        self.service.getCollections { [ self ] result in
            switch result {
            case .success(let collections):
                collectionsDatabase.updateModel(with: collections)
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
    
    func successLoadingHandle(with collectionId: String) {
        self.service.deleteCollection(collectionId: collectionId) { [ self ] result in
            switch result {
            case .success(_):
                goToCollectionsScreen()
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
    
    func successLoadingHandle(with model: [Movie]) {
        self.moviesCollection.updateModel(with: model)
    }
    
    func failureLoadingHandle(with error: Error) {
        self.errorOnLoading.updateModel(with: error)
    }
    
    func addCollectionToDatabase(with model: Collection, imageCollectionName: String) {
        let collectionDatabase = CollectionList()
        collectionDatabase.collectionName = model.name
        collectionDatabase.collectionId = model.collectionId
        collectionDatabase.nameImageCollection = imageCollectionName
        
        self.service.addNewCollection(collection: collectionDatabase) { [ self ] result in
            switch result {
            case .success(_):
                print("Add successfully")
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
}

extension CollectionScreenViewModel: ICollectionScreenViewModel {
    func getCollection() {
        self.api.getCollections { result in
            switch result {
            case .success(let collections):
                self.successLoadingHandle(with: collections)
            case .failure(let error):
                if self.api.requestStatus == .notAuthorized {
                    self.service.clearDatabase()
                    self.navigation?.goToAuthorizationScreen()
                    
                } else {
                    self.failureLoadingHandle(with: error)
                }
            }
        }
    }
    
    func addNewCollection(collectionName: String, imageCollectionName: String) {
        validation.collection = Collection(collectionId: String(), name: collectionName)
        let result = validation.isValidateDataCollection()
        
        if result == .fieldsEmpty {
            isNotValidData?(result.rawValue)
            return
        }
        
        if collectionName == "Избранное" {
            isCreatingAnotherFavoritesCollection?()
            return
        }
        
        let collectionForm = CollectionForm(name: collectionName)
        
        self.api.addNewCollection(collection: collectionForm) { [ self ] result in
            switch result {
            case .success(let newColletion):
                addCollectionToDatabase(with: newColletion, imageCollectionName: imageCollectionName)
                goToLastScreen()
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
    
    func updateCollection(collection: Collection, imageCollectionName: String) {
        deleteCollection(collectionId: collection.collectionId)

        let collectionForm = CollectionForm(name: collection.name)
        self.api.addNewCollection(collection: collectionForm) { [ self ] result in
            switch result {
            case .success(let newCollection):
                //обновляем данные в БД
                let newCollectionDatabase = CollectionList()
                newCollectionDatabase.collectionName = newCollection.name
                newCollectionDatabase.collectionId = newCollection.collectionId
                newCollectionDatabase.nameImageCollection = imageCollectionName

                self.service.updateCollection(oldCollectionId: collection.collectionId, newCollection: newCollectionDatabase) { [ self ] result in
                    switch result {
                    case .success(_):
                        goToCollectionsScreen()
                    case .failure(let error):
                        failureLoadingHandle(with: error)
                    }
                }

            case .failure(let error):
                failureLoadingHandle(with: error)
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteCollection(collectionId: String) {
        self.api.deleteCollection(collectionId: collectionId) { [ self ] result in
            switch result {
            case .success(_):
                successLoadingHandle(with: collectionId)
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
    
    func getMovieInCollection(collectionId: String) {
        self.api.getMovieInCollection(collectionId: collectionId) { [ self ] result in
            switch result {
            case .success(let movies):
                successLoadingHandle(with: movies)
            case .failure(let error):
                failureLoadingHandle(with: error)
            }
        }
    }
}
