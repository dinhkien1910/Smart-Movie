//
//  GetListSearchMovieAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 02/04/2023.
//

import Foundation

protocol GetListSearchMovieAPIProtocol {
    func getListSearchMovies(querySearch: String,
                             result: @escaping (Result<[SearchMovieResponseEntity], APIError>) -> Void)
}

final class GetListSearchMovieAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        let trimmedQuery = querySearch?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Failed to encode search query")
        }
        guard let url = URL(string:
"https://api.themoviedb.org/3/search/\(optionalPath ?? "")\(ServerConstant.APIKey.key)&query=\(encodedQuery)") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListSearchMovieAPI: GetListSearchMovieAPIProtocol {
    func getListSearchMovies(querySearch: String,
                             result: @escaping (Result<[SearchMovieResponseEntity], APIError>) -> Void) {
        let listSearchMovieURL: URL = apiURL("movie", nil, querySearch)
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listSearchMovieURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):

                do {
                    let responseEntity = try self.decodeData(data, type: ListSearchMovieResponseEntity.self)
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
