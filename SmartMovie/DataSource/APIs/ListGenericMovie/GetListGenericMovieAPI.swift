//
//  GetListGenericMovieAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation
protocol GetListGenericMovieAPIProtocol {
    func getListGenericMovies(genreID: Int, result: @escaping (Result<[GenericMovieResponseEntity], APIError>) -> Void)
}

final class GetListGenericMovieAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
"https://api.themoviedb.org/3/discover/movie\(ServerConstant.APIKey.key)&with_genres=\(optionalPath ?? "")") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListGenericMovieAPI: GetListGenericMovieAPIProtocol {
    func getListGenericMovies(genreID: Int,
                              result: @escaping (Result<[GenericMovieResponseEntity], APIError>) -> Void) {
        let listGenericMovieURL: URL = apiURL("\(genreID)", nil, nil)
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listGenericMovieURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: ListGenericMovieResponseEntity.self)
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
