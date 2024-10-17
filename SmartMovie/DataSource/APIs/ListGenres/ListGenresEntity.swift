//
//  ListGenresEntity.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation

// MARK: - ListGenreResponseEntity
struct ListGenreResponseEntity: Codable {
    let genres: [GenreResponseEntity]
}

// MARK: - GenreResponseEntity
struct GenreResponseEntity: Codable {
    let id: Int?
    let name: String?
}
