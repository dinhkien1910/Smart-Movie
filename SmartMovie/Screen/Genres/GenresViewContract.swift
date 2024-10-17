//
//  GenresViewContract.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation
// MARK: - GenresViewContractContract

protocol GenresViewContract {
    typealias Model = GenresViewModelProtocol
    typealias View = GenresViewProtocol
    typealias Presenter = GenresViewPresenterProtocol
}

// MARK: - GenresViewViewModelProtocol

protocol GenresViewModelProtocol {
    // Define your methods here
    func getListGenres(result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void)
}

// MARK: - GenresViewViewProtocol

protocol GenresViewProtocol: AnyObject {
    // Define your methods here
    func displayGenres(_ listGenres: [GenresViewEntity])
}

// MARK: - GenresViewPresenterProtocol

protocol GenresViewPresenterProtocol {
    func attach(view: GenresViewContract.View)
    func detachView()
    func fetchListGenreData()
}
