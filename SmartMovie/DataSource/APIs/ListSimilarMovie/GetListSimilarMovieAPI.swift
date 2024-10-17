//
//  GetListSimilarMovieAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 07/04/2023.
//

import Foundation
protocol GetListSimilarMovieAPIProtocol {
    func getListSimilarMovies(movieID: Int, result: @escaping (Result<[SimilarMovieResponseEntity], APIError>) -> Void)
}

final class GetListSimilarMovieAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
        "https://api.themoviedb.org/3/movie/\(optionalPath ?? "")/similar\(ServerConstant.APIKey.key)") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListSimilarMovieAPI: GetListSimilarMovieAPIProtocol {
    func getListSimilarMovies(movieID: Int,
                              result: @escaping (Result<[SimilarMovieResponseEntity], APIError>) -> Void) {

        let listSimilarMovieURL: URL = apiURL("\(movieID)", nil, nil)
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listSimilarMovieURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: ListSimilarMovieResponseEntity.self)
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
