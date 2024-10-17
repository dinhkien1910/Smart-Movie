//
//  NetworkServicesProtocol.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

public protocol NetworkServicesProtocol: AnyObject {
    func request(info: RequestInfo, result: @escaping (Result<Data, NetworkServiceError>) -> Void)
}
