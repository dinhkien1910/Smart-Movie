//
//  DetailMovieViewContract.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 05/04/2023.
//

import Foundation
// MARK: - DetailMovieViewContract

protocol DetailMovieViewContract {
    typealias Model = DetailMovieViewModelProtocol
    typealias View = DetailMovieViewProtocol
    typealias Presenter = DetailMovieViewPresenterProtocol
}

// MARK: - DetailMovieViewModelProtocol

protocol DetailMovieViewModelProtocol {
    // Define your methods here
    func getListDetailMovie(movieID: Int, result: @escaping (Result<MovieDetailResponseEntity, APIError>) -> Void)
    func getListActor(movieID: Int, result: @escaping (Result<[ActorResponseEntity], APIError>) -> Void)
    func getListSimilarMovies(movieID: Int, result: @escaping (Result<[SimilarMovieResponseEntity], APIError>) -> Void)
}

// MARK: - ADetailMovieViewProtocol

protocol DetailMovieViewProtocol: AnyObject {
    // Define your methods here
    func displayDetailMovie(_ detailMovie: DetailMovieViewEntity)
    func displayActors(_ actors: [ActorViewEntity])
    func displaySimilarMovies(_ similarMovies: [SimilarMovieViewEntity])

}

// MARK: - DetailMovieViewPresenterProtocol

protocol DetailMovieViewPresenterProtocol {
    func attach(view: DetailMovieViewContract.View)
    func detachView()
    func getDetailMovieData(movieID: Int)
    func getActorData(movieID: Int)
    func getSimilarMovieData(movieID: Int)
}
