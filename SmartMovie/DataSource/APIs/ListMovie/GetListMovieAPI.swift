//
//  GetListMovieAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

public enum MovieAPICategoryType: String {
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    case nowPlaying = "now_playing"
    static var allCases: [MovieAPICategoryType] {
           return [.popular, .topRated, .upcoming, .nowPlaying]
       }
}

protocol GetListMovieAPIProtocol {
    func getListMovies(category: String, page: Int,
                       result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
}

final class GetListMovieAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
        "https://api.themoviedb.org/3/movie/\(optionalPath ?? "")\(ServerConstant.APIKey.key)&page=\(page ?? 0)") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListMovieAPI: GetListMovieAPIProtocol {
    func getListMovies(category: String, page: Int,
                       result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        let listMovieURL: URL = apiURL("\(category)", page, "")
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listMovieURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: ListMovieResponseEntity.self)
                    result(.success(responseEntity.results))
                } catch let error {
                    print(error)
                    result(.failure(.decodeDataFailed))
                }
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }
}
