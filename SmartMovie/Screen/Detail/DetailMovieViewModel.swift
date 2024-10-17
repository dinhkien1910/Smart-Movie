//
//  DetailMovieViewModel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 05/04/2023.
//

import Foundation

struct DetailMovieViewEntity {
    let id: Int
    let name: String
    let poster: String
    let backdrop: String
    let genres: [Genre]?
    let title: String?
    let language: String
    let releaseDate: String
    let runtime: Int
    let country: String?
    let overview: String
    let averageVote: Double

    init(response: MovieDetailResponseEntity) {
        self.id = response.id ?? 0
        self.name = response.title ?? ""
        self.poster = response.posterPath ?? ""
        self.backdrop = response.backdropPath ?? ""
        self.genres = response.genres ?? []
        self.title = response.title ?? response.originalTitle
        self.language = response.spokenLanguages?.first?.name ?? ""
        self.releaseDate = response.releaseDate ?? ""
        self.runtime = response.runtime ?? 0
        if let firstCountry = response.productionCountries?.first {
               self.country = firstCountry.iso31661
           } else if let firstCompany = response.productionCompanies?.first {
               self.country = firstCompany.originCountry
           } else {
               self.country = nil
           }
        self.overview = response.overview ?? ""
        self.averageVote = response.voteAverage ?? 0
    }
}

struct ActorViewEntity {
    let name: String?
    let avatar: String?

    init(response: ActorResponseEntity) {
        self.name = response.originalName ?? response.name
        self.avatar = response.profilePath
    }
}

struct SimilarMovieViewEntity {
    // Define properties for the view entity here, if needed
    let id: Int
    let poster: String?
    let title: String?
    let overview: String?
    let voteAverage: Double?

    init(response: SimilarMovieResponseEntity) {
        self.id = response.id ?? 0
        self.poster = response.backdropPath ?? response.posterPath
        self.title = response.title ?? response.originalTitle
        self.overview = response.overview ?? ""
        self.voteAverage = response.voteAverage ?? 0
    }
}

final class DetailMovieViewModel {
    // Define properties for the model here, if needed
    private let listDetailMovieAPI: GetListDetailMovieAPIProtocol = GetListDetailMovieAPI()
    private let listActorAPI: GetListActorAPIProtocol = GetListActorAPI()
    private let listSimilarMovieAPI: GetListSimilarMovieAPIProtocol = GetListSimilarMovieAPI()

}

extension DetailMovieViewModel: DetailMovieViewModelProtocol {
    func getListDetailMovie(movieID: Int, result: @escaping (Result<MovieDetailResponseEntity, APIError>) -> Void) {
        listDetailMovieAPI.getListDetailMovies(movieID: movieID) {  responseResult in
            switch responseResult {
            case .success(let listDetailMovieResponse):
                result(.success(listDetailMovieResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }

    func getListActor(movieID: Int, result: @escaping (Result<[ActorResponseEntity], APIError>) -> Void) {
        listActorAPI.getListActors(movieID: movieID) { responseResult in
            switch responseResult {
            case .success(let listActorResponse):
                result(.success(listActorResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }

    func getListSimilarMovies(movieID: Int,
                              result: @escaping (Result<[SimilarMovieResponseEntity], APIError>) -> Void) {
        listSimilarMovieAPI.getListSimilarMovies(movieID: movieID) { responseResult in
            switch responseResult {
            case .success(let listSimilarMovieResponse):
                result(.success(listSimilarMovieResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }
}
