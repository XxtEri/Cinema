//
//  CollectionList.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit
import RealmSwift

class CollectionList: Object {
    @objc dynamic var collectionId = String()
    @objc dynamic var collectionName = String()
    @objc dynamic var nameImageCollection = String()
}

