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
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            Realm.Configuration.defaultConfiguration = configuration

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
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()

            let newCollection = CollectionList()
            newCollection.collectionId = collection.collectionId
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
    
    func updateCollection(oldCollectionId: String, newCollection: CollectionList, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            
            let realm = try Realm()

            let collectionToUpdate = realm.objects(CollectionList.self).filter { object in
                return object.collectionId == oldCollectionId
            }.first
            
            if let collection = collectionToUpdate {
                try realm.write {
                    collection.collectionId = newCollection.collectionId
                    collection.collectionName = newCollection.collectionName
                    collection.nameImageCollection = newCollection.nameImageCollection
                }
                
                completion(.success(()))
            } else {
                print("Сущность не найдена")
            }

        } catch let error as NSError {
            print("Ошибка при изменении объекта в базу данных Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func deleteCollection(collectionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()

            let collectionToDelete = realm.objects(CollectionList.self).filter { object in
                return object.collectionId == collectionId
            }
            
            try realm.write {
                realm.delete(collectionToDelete)
            }
            
            completion(.success(()))

        } catch let error as NSError {
            print("Ошибка при удалении объекта в базу данных Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func checkEntityExistsInRealm(collectionId: String) -> Bool {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()
            let results = realm.objects(CollectionList.self).filter { object in
                return object.collectionId == collectionId
            }
            
            if !results.isEmpty {
                return true
            }
            
            return false
            
        } catch let error as NSError {
            print("Ошибка при работе с Realm: \(error.localizedDescription)")
            return false
        }
    }
    
    func getFavoriteCollectionId(completion: @escaping (Result<String?, Error>) -> Void) {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()
            let results = realm.objects(CollectionList.self).filter { object in
                return object.collectionName == "Избранное"
            }
            
            if !results.isEmpty {
                completion(.success(results.first?.collectionId))
            } else {
                completion(.success(nil))
            }
            
        } catch let error {
            print("Ошибка при работе с Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func clearDatabase() {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: nil
            )
            
            Realm.Configuration.defaultConfiguration = configuration
            
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print("Ошибка при работе с Realm: \(error.localizedDescription)")
        }
    }
}
