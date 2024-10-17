//
//  HomeViewPresenter.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation
final class HomeViewPresenter {
    private weak var contentView: HomeViewContract.View?
    private var model: HomeViewContract.Model
    private var pagePopular: Int = 1
    private var pageTopRated: Int = 1
    private var pageUpComing: Int = 1
    private var pageNowPlaying: Int = 1
    private var movieEntities: [MovieAPICategoryType: [HomeViewEntity]] = [:]
    private var contentOffsetY: [MenuCategory: Double] = [:]
    private var failAPICalls = 0
    var availableCategories: [MovieAPICategoryType] = []
    let dispatchGroup: DispatchGroup = DispatchGroup()
    init(model: HomeViewContract.Model) {
        self.model = model
    }
}

extension HomeViewPresenter: HomeViewPresenterProtocol {

    func numberOfItemsInSection() -> Int {
        return 1
    }

    func numberOfSections() -> Int {
        return MenuCategory.menuCategoryCount.rawValue
    }

    func sizeForItemAt(containViewWidth: CGFloat, containViewHeight: CGFloat) -> CGSize {
        return CGSize(width: containViewWidth, height: containViewHeight)
    }

    func minimumLineSpacingForSectionAt(section: Int) -> CGFloat {
        return 0
    }

    func minimumInteritemSpacingForSectionAt(section: Int) -> CGFloat {
        return 0
    }

    func saveContentOffsetY(at categroy: Int, with contentOffset: Double) {
        contentOffsetY[MenuCategory(rawValue: categroy) ?? .movies] = contentOffset
    }

    func getContentOffsetY(at categroy: Int) -> Double {
        return contentOffsetY[MenuCategory(rawValue: categroy) ?? .movies] ?? 0
    }

    func fetchCategoryData(at categroy: Int) {
        let (category, page) = getCategoryAndPage(for: categroy)
        dispatchGroup.enter()
        model.getListMovie(categrory: category, page: page) { [weak self] result in
            switch result {
            case .success(let listMovieResponse):
                let listMovieViewEntity = listMovieResponse.map({ movieResponseEntity in
                    HomeViewEntity(response: movieResponseEntity)
                })
                self?.movieEntities[category]?.append(contentsOf: listMovieViewEntity)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.contentView?.updateData(self?.movieEntities ?? [:])
        }
    }

    private func getCategoryAndPage(for categoryMovie: Int) -> (MovieAPICategoryType, Int) {
        switch MenuCategory(rawValue: categoryMovie) {
        case .popular:
            pagePopular += 1
            return (.popular, pagePopular)
        case .topRated:
            pageTopRated += 1
            return (.topRated, pageTopRated)
        case .upcoming:
            pageUpComing += 1
            return (.upcoming, pageUpComing)
        case .nowPlaying:
            pageNowPlaying += 1
            return (.nowPlaying, pageNowPlaying)
        default:
            return (.nowPlaying, 0)
        }
    }

    func fetchAllCategoryData(showLoading: @escaping () -> Void = {}, hideLoading: @escaping () -> Void = {}) {
        showLoading()
        let batchGroup = DispatchGroup()
        for category in MovieAPICategoryType.allCases {
            batchGroup.enter()
            model.getListMovie(categrory: category, page: 1) {[weak self]  result in
                switch result {
                case .success(let listMovieResponse):
                    let listMovieViewEntity = listMovieResponse.map({ movieResponseEntity in
                        HomeViewEntity(response: movieResponseEntity)
                    })
                    self?.movieEntities[category] = listMovieViewEntity
                case .failure(let error):
                    print(error)
                    self?.failAPICalls += 1
                }
                batchGroup.leave()
            }
        }
        batchGroup.notify(queue: DispatchQueue.main) {  [weak self] in
            if self?.failAPICalls == 4 {
                self?.failAPICalls = 0
                self?.contentView?.displayAlert()
            } else {
                hideLoading()
                self?.contentView?.displayMovies(self?.movieEntities ?? [:])
            }
        }
    }

    func reloadData(at categroy: MovieAPICategoryType) {
            dispatchGroup.enter()
            model.getListMovie(categrory: categroy, page: 1) {[weak self]  result in
                switch result {
                case .success(let listMovieResponse):
                    let listMovieViewEntity = listMovieResponse.map({ movieResponseEntity in
                        HomeViewEntity(response: movieResponseEntity)
                    })
                    self?.movieEntities[categroy]? = listMovieViewEntity
                case .failure(let error):
                    print(error)
                }
                self?.dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: DispatchQueue.main) {  [weak self] in
            self?.contentView?.updateData(self?.movieEntities ?? [:])
        }
    }

    func refreshData(at categroy: MenuCategory) {
        switch categroy {
        case .movies:
            pagePopular = 1
            pageTopRated = 1
            pageUpComing = 1
            pageNowPlaying = 1
            contentOffsetY[.movies] = 0
            contentOffsetY[.popular] = 0
            contentOffsetY[.topRated] = 0
            contentOffsetY[.upcoming] = 0
            fetchAllCategoryData(showLoading: {}, hideLoading: {})
        case .popular:
            pagePopular = 1
            movieEntities[.popular] = []
            contentOffsetY[.popular] = 0
            reloadData(at: .popular)
        case .topRated:
            pagePopular = 1
            movieEntities[.topRated] = []
            contentOffsetY[.topRated] = 0
            reloadData(at: .topRated)
        case .upcoming:
            pagePopular = 1
            movieEntities[.upcoming] = []
            contentOffsetY[.upcoming] = 0
            reloadData(at: .upcoming)
        case .nowPlaying:
            pagePopular = 1
            movieEntities[.nowPlaying] = []
            contentOffsetY[.nowPlaying] = 0
            reloadData(at: .nowPlaying)
        default:
            break
        }
    }

    func attach(view: HomeViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }
}
