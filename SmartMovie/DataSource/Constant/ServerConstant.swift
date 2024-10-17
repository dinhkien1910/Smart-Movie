//
//  ServerConstant.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

struct ServerConstant {
    struct URLBase {
        static var baseURL = "https://api.themoviedb.org/3/"
    }

    struct APIPath {
        static let movie = "movie/"
        static let search = "search/"
        static let genre = "genre/movie/list"
        static let discover = "discover/movie"
        static let credits = "/credits"
        static let similar = "/similar"
    }

    struct APIKey {
        static let key = "?api_key=d5b97a6fad46348136d87b78895a0c06"
    }

    struct URLPath {
        static var listActor = "https://api.themoviedb.org/3/movie/"
    }
}
