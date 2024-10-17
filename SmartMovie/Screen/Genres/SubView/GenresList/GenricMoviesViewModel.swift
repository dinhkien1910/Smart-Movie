//
//  GenresListViewModel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation

struct GenericMoviesViewEntity {
        let id: Int
        let poster: String?
        let title: String?
        let overview: String?
        init(response: GenericMovieResponseEntity) {
            self.id = response.id ?? 0
            self.poster = response.posterPath ?? ""
            self.title = response.title ?? response.originalTitle
            self.overview = response.overview ?? ""
        }
}

final class GenericMoviesViewModel {
    // Define properties for the model here, if needed
    private let listGenericMovieAPI: GetListGenericMovieAPIProtocol = GetListGenericMovieAPI()
}

extension GenericMoviesViewModel: GenericMoviesViewModelProtocol {
    func getListGenericMovies(genreID: Int,
                              result: @escaping (Result<[GenericMovieResponseEntity], APIError>) -> Void) {
        listGenericMovieAPI.getListGenericMovies(genreID: genreID) { responseResult in
            switch responseResult {
            case .success(let listGenreResponse):
                result(.success(listGenreResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }
}
