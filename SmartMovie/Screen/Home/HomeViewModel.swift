//
//  HomeViewModel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation
struct HomeViewEntity {
        let id: Int
        let poster: String?
        let title: String?
        let overview: String?

        init(response: MovieResponseEntity) {
            self.id = response.id ?? 0
            self.poster = response.posterPath ?? ""
            self.title = response.title ?? response.originalTitle
            self.overview = response.overview ?? ""
        }
}

final class HomeViewModel {
    private let listMovieAPI: GetListMovieAPIProtocol = GetListMovieAPI()
}

extension HomeViewModel: HomeViewModelProtocol {
    func getListMovie(categrory: MovieAPICategoryType, page: Int,
                      result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listMovieAPI.getListMovies(category: categrory.rawValue, page: page ) { responseResult in
            switch responseResult {
            case .success(let listTrendingResponse):
                result(.success(listTrendingResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }
}
