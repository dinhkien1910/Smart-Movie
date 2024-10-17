//
//  NetworkServices.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

final class NetworkServices {
    private let session: URLSession
    private var dataTask: URLSessionDataTask?

    static func defaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0

        let session = URLSession(configuration: config)

        return session
    }

    init(session: URLSession = NetworkServices.defaultSession()) {
        self.session = session
    }
}

extension NetworkServices: NetworkServicesProtocol {
    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        dataTask = session.dataTask(with: info.urlInfo) { data, response, error in
            if let error = error?.localizedDescription {
                print(error)
                result(.failure(.serverError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(.serverError))
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    result(.failure(.noData))
                    return
                }
                result(.success(data))
            case 401:
                result(.failure(.authenError))
            default:
                result(.failure(.serverError))
            }
        }
        dataTask?.resume()
    }
}
