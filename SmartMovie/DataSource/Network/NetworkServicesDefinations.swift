//
//  NetworkServicesDefinations.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

public enum NetworkServiceError: Error {
    case serverError
    case authenError
    case noData
    case encodeFailed
}

public typealias HTTPHeaders        = [String: Any]
public typealias RequestParameters  = [String: Any]

public struct RequestInfo {
    var urlInfo: URL
    var httpMethod: HTTPMethod
    var header: HTTPHeaders?
    var params: RequestParameters?

    init(urlInfo: URL, httpMethod: HTTPMethod, header: HTTPHeaders? = nil, params: RequestParameters? = nil) {
        self.urlInfo = urlInfo
        self.httpMethod = httpMethod
        self.header = header
        self.params = params
    }
}
