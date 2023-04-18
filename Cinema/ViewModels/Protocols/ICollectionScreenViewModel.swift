//
//  ICollectionScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import Foundation

protocol ICollectionScreenViewModel {
    func addNewCollection(collectionName: String, imageCollectionName: String)
    func updateCollection(collection: Collection, imageCollectionName: String)
    func deleteCollection(collectionId: String)
    
    func getMovieInCollection(collectionId: String)
}
