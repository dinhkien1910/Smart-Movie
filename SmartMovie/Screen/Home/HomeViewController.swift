//
//  HomeViewController.swift
//  SmartMovie
//
//  Created by KhanhVD1.APL on 3/28/23.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Variables
    private var presenter: HomeViewPresenterProtocol = HomeViewPresenter(model: HomeViewModel())
    private var homeMovies: [MovieAPICategoryType: [HomeViewEntity]] = [:]

    // MARK: - IBOutlet
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var btnChangeStyle: UIButton!
    var isGrid = true {
        didSet {
            categoryCollectionView.reloadData()
        }
    }

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        setupCustomTabBar()
        setupCategoryCollectionView()
        setupUI()
        // Do any additional setup after loading the view.
        presenter.fetchAllCategoryData(
            showLoading: { [weak self] in
                self?.showLoading()
            },
            hideLoading: { [weak self] in
                self?.hideLoading()
            }
        )
        categoryCollectionView.isPrefetchingEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCollectionView.reloadData()
    }

    private func showLoading() {
            guard let loadingView = loadingView else {
                return
            }
            loadingView.startAnimating()
        overlayView.isHidden = false
        }

    private func hideLoading() {
            DispatchQueue.main.async { [weak self] in
                   self?.loadingView?.stopAnimating()
                self?.overlayView.isHidden = true
               }
        }

    @IBAction func invokeChangeGrid(_ sender: Any) {
        isGrid = !isGrid
        if !isGrid {
            btnChangeStyle.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        } else {
            btnChangeStyle.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        }
    }

    // MARK: Setup view
    private func setupCustomTabBar() {
        menuBar.delegate = self
        menuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 5
    }

    private func setupCategoryCollectionView( ) {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.isPagingEnabled = true
        categoryCollectionView.register(UINib(nibName: MenuViewCell.reusableIdentifier,
                                              bundle: nil),
                                        forCellWithReuseIdentifier: MenuViewCell.reusableIdentifier)
        categoryCollectionView.register(UINib(nibName: CategroryViewCell.reusableIdentifier,
                                              bundle: nil),
                                        forCellWithReuseIdentifier: CategroryViewCell.reusableIdentifier)
    }

    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = layout
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                    UIColor(red: 0.90, green: 0.03, blue: 0.08, alpha: 1.0)]
        tabBarController?.tabBar.unselectedItemTintColor = .gray
        overlayView.isHidden = true
    }
}

extension HomeViewController: MenuBarDelegate {
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 5
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: 0, section: itemAt)
        menuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listHomeMovies = homeMovies

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategroryViewCell.reusableIdentifier, for: indexPath) as? CategroryViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.delegateCell = self
        cell.isGrid = isGrid
        cell.movieCollectionView.tag = indexPath.section
        cell.setupData(with: listHomeMovies, presenter)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return presenter.sizeForItemAt(containViewWidth: categoryCollectionView.frame.width,
                                       containViewHeight: categoryCollectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return presenter.minimumLineSpacingForSectionAt(section: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return presenter.minimumInteritemSpacingForSectionAt(section: section)
        }
}

extension HomeViewController: HomeViewProtocol {
    func displayAlert() {
        let alertController = UIAlertController(title: "Load data failed",
                                message: "Can't get data from sever, please try again later", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Reload", style: .default) { _ in
                            self.presenter.fetchAllCategoryData(
                                showLoading: { [weak self] in
                                    self?.showLoading()
                                },
                                hideLoading: { [weak self] in
                                    self?.hideLoading()
                                }
                        )
                }
                        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func scrollToSection(scrollTo index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        menuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

    func refreshData(at categroy: MenuCategory) {
        presenter.refreshData(at: categroy)
    }

    func loadMoreCategoryData(at categroy: Int) {
        presenter.fetchCategoryData(at: categroy)
    }

    func displayMovies(_ listMovies: [MovieAPICategoryType: [HomeViewEntity]]) {
        homeMovies = listMovies
        categoryCollectionView.reloadData()
    }

    func updateData(_ listMovies: [MovieAPICategoryType: [HomeViewEntity]]) {
        homeMovies = listMovies
        categoryCollectionView.reloadData()
    }
}

extension HomeViewController: CategroryViewCellDelegate {
    func didTapItem(movieID: Int) {
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        if let detailMovieVC = storyboard.instantiateViewController(
            withIdentifier: DetailMovieViewController.reusableIdentifier) as? DetailMovieViewController {
            detailMovieVC.movieID = movieID
            navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
}
