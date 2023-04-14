//
//  CollectionService.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import RealmSwift
import UIKit

class CollectionService {
    var collectionList: Results<CollectionList>!
    
    var endingChangeDatabase: (() -> Void)?
    
    func getCollections(completion: @escaping (Result<Results<CollectionList>, Error>) -> Void) {
        do {
            let realm = try Realm()
            
            collectionList = realm.objects(CollectionList.self)
            
            completion(.success(collectionList))
            
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func addNewCollection(collection: CollectionList, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 1 {

                    }
                }
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()

            let newCollection = CollectionList()
            newCollection.collectionName = collection.collectionName
            newCollection.nameImageCollection = collection.nameImageCollection

            try realm.write {
                realm.add(newCollection)
            }
            
            completion(.success(()))

        } catch let error as NSError {
            print("Ошибка при добавлении объекта в базу данных Realm: \(error.localizedDescription)")
            
            completion(.failure(error))
        }
    }
    
    func updateCollection(collection: CollectionList) {
        do {
            let realm = try Realm()

            let collectionToUpdate = realm.objects(CollectionList.self).filter { object in
                return object.collectionId == collection.collectionId
            }
            
            try realm.write {
                collectionToUpdate[0].collectionName = collection.collectionName
                collectionToUpdate[0].nameImageCollection = collection.nameImageCollection
            }
            
            endingChangeDatabase?()

        } catch let error as NSError {
            print("Ошибка при изменении объекта в базу данных Realm: \(error.localizedDescription)")
        }
    }
    
    func deleteCollection(collection: CollectionList) {
        do {
            let realm = try Realm()

            let collectionToDelete = realm.objects(CollectionList.self).filter { object in
                return object.collectionId == collection.collectionId
            }
            
            try realm.write {
                realm.delete(collectionToDelete)
            }
            
            endingChangeDatabase?()

        } catch let error as NSError {
            print("Ошибка при удалении объекта в базу данных Realm: \(error.localizedDescription)")
        }
    }
}
