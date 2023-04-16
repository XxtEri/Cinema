//
//  Protocols.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

protocol IApiRepositoryAuth {
    func signIn(user: LoginCredential, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(user: RegisterCredential, completion: @escaping (Result<Void, Error>) -> Void)
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryMain {
    func getCoverFilm(completion: @escaping (Result<CoverMovie, Error>) -> Void)
    func getMovies(typeListMovie: TypeListMovieMainScreen, completion: @escaping (Result<[Movie], Error>) -> Void)
    func getHistoryMovie(completion: @escaping (Result<[EpisodeView], Error>) -> Void)
    func getEpisodesMovie(movieId: String, completion: @escaping (Result<[Episode], Error>) -> Void)
    func getCurrentEpisodeTime(episodeId: String, completion: @escaping (Result<EpisodeTime, Error>) -> Void)
    func saveCurrentEpisodeTime(episodeId: String, time: EpisodeTime, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol IApiRepositoryProfile {
    func getInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func editInformationProfile(completion: @escaping (Result<User, Error>) -> Void)
    func uploadPhoto(completion: @escaping (Result<User, Error>) -> Void)
}
