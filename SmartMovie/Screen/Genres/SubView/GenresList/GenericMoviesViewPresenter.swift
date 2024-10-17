//
//  GenresListViewPresenter.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import Foundation
final class GenericMoviesViewPresenter {
    private weak var contentView: GenericMoviesViewContract.View?
    private var model: GenericMoviesViewContract.Model
    private var genericMovies: [GenericMoviesViewEntity] = []
    init(model: GenericMoviesViewContract.Model) {
        self.model = model
    }
}

extension GenericMoviesViewPresenter: GenericMoviesViewPresenterProtocol {
    func numberOfRowsInSection() -> Int {
        return genericMovies.count
    }

    func fetchListGenreData(genreID: Int) {
        model.getListGenericMovies(genreID: genreID) { [weak self] result in
            switch result {
            case .success(let listGenericMoviesResponse):
                // Convert response entity to view entity
                let listGenericMoviesEntity = listGenericMoviesResponse.map({ genericMovieResponseEntity in
                    GenericMoviesViewEntity(response: genericMovieResponseEntity)
                })
                self?.genericMovies = listGenericMoviesEntity
                DispatchQueue.main.async {
                    self?.contentView?.displayGenericMovies(listGenericMoviesEntity)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func attach(view: GenericMoviesViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }
}
