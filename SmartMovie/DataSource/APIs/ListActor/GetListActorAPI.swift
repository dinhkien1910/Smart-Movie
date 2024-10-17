//
//  GetListActorAPI.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 05/04/2023.
//

import Foundation
protocol GetListActorAPIProtocol {
    func getListActors(movieID: Int, result: @escaping (Result<[ActorResponseEntity], APIError>) -> Void)
}

final class GetListActorAPI: BaseAPIFetcher {
    override func apiURL(_ optionalPath: String?, _ page: Int?, _ querySearch: String?) -> URL {
        guard let url = URL(string:
        "https://api.themoviedb.org/3/movie/\(optionalPath ?? "")/credits\(ServerConstant.APIKey.key)") else {
            fatalError("Login URL failed")
    }
        return url
    }
}

extension GetListActorAPI: GetListActorAPIProtocol {
    func getListActors(movieID: Int, result: @escaping (Result<[ActorResponseEntity], APIError>) -> Void) {

        // Prepare login URL
        let listActorURL: URL = apiURL("\(movieID)", nil, nil)
        let requestInfo: RequestInfo = RequestInfo(urlInfo: listActorURL, httpMethod: .get, params: nil)

        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                print("GetListTrendingAPI nil before complete callback")
                result(.failure(.decodeDataFailed))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: ListActorResponseEntity.self)
                    result(.success(responseEntity.cast))
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
