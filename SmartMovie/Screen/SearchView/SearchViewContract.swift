//
//  SearchViewContract.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation
// MARK: - SearchViewContractContract

protocol SearchViewContract {
    typealias Model = SearchViewModelProtocol
    typealias View = SearchViewProtocol
    typealias Presenter = SearchViewPresenterProtocol
}

// MARK: - SearchViewViewModelProtocol

protocol SearchViewModelProtocol {
    func getListSearchMovie(querySearch: String,
                            result: @escaping (Result<[SearchMovieResponseEntity], APIError>) -> Void)}

// MARK: - SearchViewViewProtocol

protocol SearchViewProtocol: AnyObject {
    func displaySearchMovies(_ listMovies: [SearchViewEntity])
}

// MARK: - SearchViewPresenterProtocol

protocol SearchViewPresenterProtocol {
    func attach(view: SearchViewContract.View)
    func detachView()
//    func searchMovie(nameMovie: String)
    func searchMovie(nameMovie: String, completion: @escaping (Bool) -> Void)

    func numberOfRowsInSection () -> Int
}
