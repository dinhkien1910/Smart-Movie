//
//  HomeViewContract.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation

protocol HomeViewContract {
    typealias Model = HomeViewModelProtocol
    typealias View = HomeViewProtocol
    typealias Presenter = HomeViewPresenterProtocol
}

protocol HomeViewModelProtocol {
    func getListMovie(categrory: MovieAPICategoryType, page: Int,
                      result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)

}

protocol HomeViewProtocol: AnyObject {
    func displayMovies(_ listMovies: [MovieAPICategoryType: [HomeViewEntity]])
    func displayAlert()
    func updateData(_ listMovies: [MovieAPICategoryType: [HomeViewEntity]])
    func loadMoreCategoryData(at categroy: Int)
    func refreshData(at categroy: MenuCategory)
    func scrollToSection(scrollTo index: Int)
}

protocol HomeViewPresenterProtocol {
    func attach(view: HomeViewContract.View)
    func detachView()
    func refreshData(at categroy: MenuCategory)
    func fetchAllCategoryData(showLoading: @escaping () -> Void, hideLoading: @escaping () -> Void)
    func reloadData(at categroy: MovieAPICategoryType)
    func fetchCategoryData(at categroy: Int)
    func saveContentOffsetY(at categroy: Int, with contentOffset: Double)
    func getContentOffsetY(at categroy: Int) -> Double
    // collectionView
    func sizeForItemAt(containViewWidth: CGFloat, containViewHeight: CGFloat) -> CGSize
    func minimumLineSpacingForSectionAt(section: Int) -> CGFloat
    func minimumInteritemSpacingForSectionAt(section: Int) -> CGFloat
    func numberOfItemsInSection() -> Int
    func numberOfSections() -> Int
}
