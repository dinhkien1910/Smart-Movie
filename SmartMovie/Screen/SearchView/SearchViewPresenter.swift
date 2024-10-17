//
//  SearchViewPresenter.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import Foundation

final class SearchViewPresenter {
    private weak var contentView: SearchViewContract.View?
    private var model: SearchViewContract.Model
    private var searchMovies: [SearchViewEntity] = []

    init(model: SearchViewContract.Model) {
        self.model = model
    }
}

extension SearchViewPresenter: SearchViewPresenterProtocol {
    func numberOfRowsInSection() -> Int {
        return searchMovies.count
    }

    func searchMovie(nameMovie: String, completion: @escaping (Bool) -> Void) {
        if nameMovie.isEmpty {
            searchMovies = []
            DispatchQueue.main.async { [weak self] in
                self?.contentView?.displaySearchMovies(self?.searchMovies ?? [])
                completion(false)
            }
        } else {
            model.getListSearchMovie(querySearch: nameMovie) { [weak self] result in
                switch result {
                case .success(let listSearchMovieResponse):
                    // Convert response entity to view entity
                    let listSearchViewEntity = listSearchMovieResponse.map({ searchMovieResponseEntity in
                        SearchViewEntity(response: searchMovieResponseEntity)
                    })
                    self?.searchMovies = listSearchViewEntity
                    DispatchQueue.main.async { [weak self] in
                        self?.contentView?.displaySearchMovies(listSearchViewEntity)
                        if listSearchViewEntity.isEmpty {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
        }
    }

    func attach(view: SearchViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }
}
