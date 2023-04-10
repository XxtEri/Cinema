//
//  Movie.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

struct Movie: Decodable {
    let movieId: String
    let name: String
    let description: String
    let age: Age
    let chatInfo: Chat
    let imageUrls: [String]
    let poster: String
    let tags: [Tag]
}

enum Age: String, Decodable {
    case zero = "0+"
    case six = "6+"
    case twelve = "12+"
    case sixteen = "16+"
    case eighteen = "18+"
}

enum TypeListMovieMainScreen: String, Decodable {
    case trend = "inTrend"
    case new = "new"
    case recomendation = "forMe"
}
