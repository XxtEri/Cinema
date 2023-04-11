//
//  Episode.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

struct Episode: Decodable {
    let episodeId: String
    let name: String
    let description: String
    let director: String
    let stars: [String]
    let year: Int
    let images: [String]
    let runtime: Int
    let preview: String
    let filePath: String
}
