//
//  GenresListViewContract.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation
// MARK: - GenericMoviesViewContract

protocol GenericMoviesViewContract {
    typealias Model = GenericMoviesViewModelProtocol
    typealias View = GenericMoviesViewProtocol
    typealias Presenter = GenericMoviesViewPresenterProtocol
}

// MARK: - GenericMoviesViewModelProtocol

protocol GenericMoviesViewModelProtocol {
    // Define your methods here
    func getListGenericMovies(genreID: Int, result: @escaping (Result<[GenericMovieResponseEntity], APIError>) -> Void)
}

// MARK: - GenericMoviesViewProtocol

protocol GenericMoviesViewProtocol: AnyObject {
    // Define your methods here
    func displayGenericMovies(_ listMovies: [GenericMoviesViewEntity])
}

// MARK: - GenericMoviesViewPresenterProtocol

protocol GenericMoviesViewPresenterProtocol {
    func attach(view: GenericMoviesViewContract.View)
    func detachView()
    func fetchListGenreData(genreID: Int)
    func numberOfRowsInSection () -> Int
}
