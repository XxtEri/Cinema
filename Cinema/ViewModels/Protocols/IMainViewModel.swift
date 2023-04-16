//
//  IMainScreenViewModel.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

protocol IMainViewModel {
    var coverMovie: Observable<CoverMovie> { get }
    var errorOnLoading: Observable<Error> { get }
    
    func getCoverImage()
    func getMovies()
    func getEpisodesMovie(movieId: String)
    func getEpisodeTime(episodeId: String)
    func saveEpisodeTime(episodeId: String, time: EpisodeTime)
}
