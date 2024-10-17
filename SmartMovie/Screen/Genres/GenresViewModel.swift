//
//  GenresViewModel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation

struct GenresViewEntity {
    // Define properties for the view entity here, if needed
    let id: Int
    let name: String?

    init(response: GenreResponseEntity) {
        self.id = response.id ?? 0
        self.name = response.name ?? ""
    }
}

final class GenresViewModel {
    // Define properties for the model here, if needed
    private let listGenreAPI: GetListGenresAPIProtocol = GetListGenresAPI()
}

extension GenresViewModel: GenresViewModelProtocol {
    func getListGenres(result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void) {
        listGenreAPI.getListGenres { responseResult in
            switch responseResult {
            case .success(let listGenreResponse):
                result(.success(listGenreResponse))
            case .failure:
                result(.failure(.unknowError))
            }
        }
    }
}
