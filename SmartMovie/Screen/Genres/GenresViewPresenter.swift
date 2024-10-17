//
//  GenresViewPresenter.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation

final class GenresViewPresenter {
    private weak var contentView: GenresViewContract.View?
    private var model: GenresViewContract.Model
    init(model: GenresViewContract.Model) {
        self.model = model
    }
}

extension GenresViewPresenter: GenresViewPresenterProtocol {
    func fetchListGenreData() {
        model.getListGenres { [weak self] result in
            switch result {
            case .success(let listGenreResponse):
                // Convert response entity to view entity
                let listGenreEntity = listGenreResponse.map({ searchMovieResponseEntity in
                    GenresViewEntity(response: searchMovieResponseEntity)
                })
                DispatchQueue.main.async {
                    self?.contentView?.displayGenres(listGenreEntity)
                }
            case .failure(let error):
                print(error)
            }
        }
        }

    func attach(view: GenresViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }
}
