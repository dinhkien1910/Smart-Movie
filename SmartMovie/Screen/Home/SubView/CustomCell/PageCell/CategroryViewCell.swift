//
//  CategroryViewCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import UIKit
import Foundation
protocol CategroryViewCellDelegate: AnyObject {
    func didTapItem(movieID: Int)
}

enum CellType: Int {
    case popular
    case topRated
    case upcoming
    case nowPlaying
    case cellTypeCount
}

class CategroryViewCell: UICollectionViewCell {
    private var popularMovies: [HomeViewEntity] = []
    private var topRatedMovies: [HomeViewEntity] = []
    private var upcomingMovies: [HomeViewEntity] = []
    private var nowPlayingMovies: [HomeViewEntity] = []
    private var presenter: HomeViewPresenterProtocol = HomeViewPresenter(model: HomeViewModel())
    private var isLoading = false
    var isGrid = true {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    private var refreshControl = UIRefreshControl()
    weak var delegate: HomeViewProtocol?
    weak var delegateCell: CategroryViewCellDelegate?
    @IBOutlet weak var loadMoreView: UIActivityIndicatorView!
    @IBOutlet weak var movieCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        refreshControl.tintColor = UIColor.white
        // Add pull-to-refresh to collection view
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        movieCollectionView.refreshControl = refreshControl
        // Initialization code
        setupDelegate()
        setupUI()
        loadMoreView.isHidden = true
    }

    func setupData(with data: [MovieAPICategoryType: [HomeViewEntity]], _ presenter: HomeViewPresenterProtocol) {
            for (category, movies) in data {
                switch category {
                case .popular:
                    popularMovies = movies
                case .topRated:
                    topRatedMovies = movies
                case .upcoming:
                    upcomingMovies = movies
                case .nowPlaying:
                    nowPlayingMovies = movies
                }
            }
            self.presenter = presenter
            isLoading = true
            let savedContentOffset = presenter.getContentOffsetY(at: movieCollectionView.tag)
            movieCollectionView.setContentOffset(CGPoint(x: 0, y: savedContentOffset), animated: false)
        }

    @objc func refreshData() {
        guard let category = MenuCategory(rawValue: movieCollectionView.tag) else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            delegate?.refreshData(at: category)
            refreshControl.endRefreshing()
        }
    }

    override func prepareForReuse() {
        popularMovies = []
        topRatedMovies = []
        upcomingMovies = []
        nowPlayingMovies = []
        movieCollectionView.contentOffset = CGPoint()
        movieCollectionView.reloadData()
    }

    func showLoading() {
        loadMoreView.isHidden = false
        loadMoreView.startAnimating()
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadMoreView.stopAnimating()
            self?.loadMoreView.isHidden = true
        }
    }

    private func setupDelegate() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: ListViewCell.reusableIdentifier,
                                           bundle: .main), forCellWithReuseIdentifier: ListViewCell.reusableIdentifier)
        movieCollectionView.register(UINib(nibName: GridViewCell.reusableIdentifier,
                                           bundle: .main), forCellWithReuseIdentifier: GridViewCell.reusableIdentifier)
        movieCollectionView.register(UINib(nibName: HeaderHomeViewCell.reusableIdentifier,
                                           bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: HeaderHomeViewCell.reusableIdentifier)
    }

    private func setupUI() {
        movieCollectionView.backgroundColor = .nfBlack
    }
}

// MARK: - UICollectionViewDelegate
extension CategroryViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryMovie = collectionView.tag
        let listMovies = getListMovies(for: categoryMovie, at: indexPath)
        delegateCell?.didTapItem(movieID: listMovies[indexPath.item].id)
    }
}

// MARK: - UICollectionViewDataSource
extension CategroryViewCell: UICollectionViewDataSource {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if movieCollectionView.tag == 0 {
            presenter.saveContentOffsetY(at: movieCollectionView.tag, with: scrollView.contentOffset.y)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard collectionView == movieCollectionView else { return }
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 20.0 && movieCollectionView.tag != 0 && isLoading {
            showLoading()
            isLoading = false
            presenter.saveContentOffsetY(at: movieCollectionView.tag, with: scrollView.contentOffset.y)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.delegate?.loadMoreCategoryData(at: movieCollectionView.tag)
                self.hideLoading()
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if MenuCategory(rawValue: movieCollectionView.tag) == .movies {
            return CellType.cellTypeCount.rawValue
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countItem: Int = 0
        switch MenuCategory(rawValue: collectionView.tag) {
        case .movies:
            countItem = getCountListMovies(for: CellType(rawValue: section) ?? .popular)
        case .popular:
            countItem = popularMovies.count
        case .topRated:
            countItem = topRatedMovies.count
        case .upcoming:
            countItem = upcomingMovies.count
        case .nowPlaying:
            countItem = nowPlayingMovies.count
        default:
            countItem = 0
        }
        return countItem
    }

    private func getCountListMovies(for categoryMovie: CellType) -> Int {
                switch categoryMovie {
                case .popular:
                   return popularMovies.prefix(4).count
                case .topRated:
                    return topRatedMovies.prefix(4).count
                case .upcoming:
                    return upcomingMovies.prefix(4).count
                case .nowPlaying:
                    return nowPlayingMovies.prefix(4).count
                default:
                    return popularMovies.prefix(4).count
                }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryMovie = collectionView.tag
        let listMovies = getListMovies(for: categoryMovie, at: indexPath)

        guard let cellList = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListViewCell.reusableIdentifier, for: indexPath) as? ListViewCell,
              let cellGrid = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridViewCell.reusableIdentifier, for: indexPath) as? GridViewCell
               else {
            return UICollectionViewCell()
        }

        if isGrid {
            cellGrid.setupData(with: listMovies[indexPath.item])
            return cellGrid
        } else {
            cellList.setupData(with: listMovies[indexPath.item])
            return cellList
        }
    }

    private func getListMovies(for categoryMovie: Int,
                               at indexPath: IndexPath) -> [HomeViewEntity] {
        switch MenuCategory(rawValue: categoryMovie) {
        case .movies:
            return getMovies(for: CellType(rawValue: indexPath.section) ?? .nowPlaying)
        case .popular:
            return popularMovies
        case .topRated:
            return topRatedMovies
        case .upcoming:
            return upcomingMovies
        case .nowPlaying:
            return nowPlayingMovies
        default:
            return []
        }
    }

    private func getMovies(for categoryMovie: CellType) -> [HomeViewEntity] {
                switch categoryMovie {
                case .popular:
                    return popularMovies
                case .topRated:
                    return topRatedMovies
                case .upcoming:
                    return upcomingMovies
                case .nowPlaying:
                    return nowPlayingMovies
                default:
                    return []
                }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderHomeViewCell.reusableIdentifier,
            for: indexPath) as? HeaderHomeViewCell else {
            return UICollectionReusableView()
        }
        if MenuCategory(rawValue: movieCollectionView.tag) == .movies {
            headerView.isHidden = false
            headerView.delegate = delegate
            switch CellType(rawValue: indexPath.section) {
            case .popular:
                headerView.setupData(section: .popular)
                return headerView
            case .topRated:
                headerView.setupData(section: .topRated)
                return headerView
            case .upcoming:
                headerView.setupData(section: .upcoming)
                return headerView
            case .nowPlaying:
                headerView.setupData(section: .nowPlaying)
                return headerView
            default:
                return UICollectionViewCell()
            }
        } else {
            headerView.isHidden = true
            return headerView
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if MenuCategory(rawValue: movieCollectionView.tag) == .movies {
            return CGSize(width: contentView.frame.size.width, height: 50)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategroryViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid {
            return CGSize(width: (collectionView.frame.size.width - 16 * 3) / 2,
                          height: collectionView.frame.size.height / 2.1)
        } else {
            return CGSize(width: collectionView.frame.size.width - 16 * 2,
                          height: collectionView.frame.size.height / 4)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if isGrid {
            return UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        } else {
            return UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        }
    }
}
