//
//  ListActorEntity.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 05/04/2023.
//

import Foundation

// MARK: - ListActorResponseEntity
struct ListActorResponseEntity: Codable {
    let movieID: Int?
    let cast: [ActorResponseEntity]
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case cast
    }
}

// MARK: - ActorResponseEntity
struct ActorResponseEntity: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}
