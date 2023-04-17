//
//  EpisodeView.swift
//  Cinema
//
//  Created by Елена on 06.04.2023.
//

struct EpisodeView: Decodable {
    let episodeId: String
    let movieId: String
    let episodeName: String
    let movieName: String
    let preview: String
    let filePath: String
    let time: Int
}
