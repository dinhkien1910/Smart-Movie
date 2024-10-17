//
//  DetailMoviePresenter.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 05/04/2023.
//

import Foundation

final class DetailMovieViewPresenter {
    private weak var contentView: DetailMovieViewContract.View?
    private var model: DetailMovieViewContract.Model
    private let dispatchGroup = DispatchGroup()
    init(model: DetailMovieViewContract.Model) {
        self.model = model
    }
}

extension DetailMovieViewPresenter: DetailMovieViewPresenterProtocol {
    func getSimilarMovieData(movieID: Int) {
        model.getListSimilarMovies(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let listSimilarMovieResponse):
                // Convert response entity to view entity
                let listSimilarMoviesEntity = listSimilarMovieResponse.map({ similarMovieResponseEntity in
                    SimilarMovieViewEntity(response: similarMovieResponseEntity)
                })
                DispatchQueue.main.async {
                    self?.contentView?.displaySimilarMovies(listSimilarMoviesEntity)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func getDetailMovieData(movieID: Int) {
        model.getListDetailMovie(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let listDetailMovieResponse):
                // Convert response entity to view entity
                let listDetailMoviesEntity = DetailMovieViewEntity(response: listDetailMovieResponse)
                DispatchQueue.main.async {
                    self?.contentView?.displayDetailMovie(listDetailMoviesEntity)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func getActorData(movieID: Int) {
        model.getListActor(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let listActorResponse):
                // Convert response entity to view entity
                let listActorsEntity = listActorResponse.map({ actorResponseEntity in
                    ActorViewEntity(response: actorResponseEntity)
                })
                DispatchQueue.main.async {
                    self?.contentView?.displayActors(listActorsEntity)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

        func attach(view: DetailMovieViewContract.View) {
            contentView = view
        }

        func detachView() {
            contentView = nil
        }
    }
