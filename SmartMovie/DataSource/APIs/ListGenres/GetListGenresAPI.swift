//
//  GetListGenresAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation

protocol GetListGenresAPIProtocol {
    func getListGenres( result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void)
}

final class GetListGenresAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
                "https://api.themoviedb.org/3/genre/movie/list\(ServerConstant.APIKey.key)") else {
            fatalError("Login URL failed")
        }
        return url
    }
}

extension GetListGenresAPI: GetListGenresAPIProtocol {
    func getListGenres(result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void) {
        // Prepare login URL
        let listGenresURL: URL = apiURL("", 0, "")
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listGenresURL, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListGenreResponseEntity.self)
                    result(.success(responseEntity.genres))
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
