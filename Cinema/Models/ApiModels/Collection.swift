//
//  Collection.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import Foundation

struct Collection: Decodable {
    let collectionId: String
    let name: String
}

struct CollectionForm: Encodable {
    let name: String
}
