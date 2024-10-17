//
//  GetListDetailMovieApI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 31/03/2023.
//

import Foundation
protocol GetListDetailMovieAPIProtocol {
    func getListDetailMovies(movieID: Int, result: @escaping (Result<MovieDetailResponseEntity, APIError>) -> Void)
}

final class GetListDetailMovieAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
            "https://api.themoviedb.org/3/movie/\(optionalPath ?? "")\(ServerConstant.APIKey.key)") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListDetailMovieAPI: GetListDetailMovieAPIProtocol {
    func getListDetailMovies(movieID: Int, result: @escaping (Result<MovieDetailResponseEntity, APIError>) -> Void) {
        let listDetailMovieURL: URL = apiURL("\(movieID)", 0, "")

        let requestInfo: RequestInfo = RequestInfo(urlInfo: listDetailMovieURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: MovieDetailResponseEntity.self)
                    result(.success(responseEntity))
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
