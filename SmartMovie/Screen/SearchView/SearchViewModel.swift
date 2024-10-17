//
//  SearchViewModel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation

struct SearchViewEntity {
    // Define properties for the view entity here, if needed
    let id: Int
    let poster: String?
    let title: String?
    let overview: String?
    let voteAverage: Double?

    init(response: SearchMovieResponseEntity) {
        self.id = response.id ?? 0
        self.poster = response.backdropPath ?? response.posterPath
        self.title = response.title ?? response.originalTitle
        self.overview = response.overview ?? ""
        self.voteAverage = response.voteAverage ?? 0
    }
}

final class SearchViewModel {
    private let listSearchMovieAPI: GetListSearchMovieAPIProtocol = GetListSearchMovieAPI()
}

extension SearchViewModel: SearchViewModelProtocol {
    func getListSearchMovie(querySearch: String,
                            result: @escaping (Result<[SearchMovieResponseEntity], APIError>) -> Void) {
        listSearchMovieAPI.getListSearchMovies(querySearch: querySearch) { responseResult in
            switch responseResult {
            case .success(let listSearchMovieResponse):
                result(.success(listSearchMovieResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }
}
