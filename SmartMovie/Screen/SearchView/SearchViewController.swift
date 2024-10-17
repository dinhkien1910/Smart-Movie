//
//  SearchViewViewController.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import UIKit
class SearchViewController: UIViewController {
    // MARK: - Variables
    private var presenter: SearchViewPresenterProtocol = SearchViewPresenter(model: SearchViewModel())
    private var listSearchMovies: [SearchViewEntity] = []
    private var searchTimer: Timer?
    // MARK: - IBOutlet
    @IBOutlet weak var imgSearchNotFound: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        setupMoviesTableView()
        setupUI()
    }

    private func setupMoviesTableView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.registerCell(type: SearchMoviesCell.self)
    }

    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                UIColor(red: 0.90, green: 0.03, blue: 0.08, alpha: 1.0)]
        searchBar.searchTextField.leftView?.tintColor = UIColor.nfWhite
        overlayView.isHidden = true
        imgSearchNotFound.isHidden = false
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
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movies = listSearchMovies[indexPath.row]
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        if let detailMovieVC = storyboard.instantiateViewController(
            withIdentifier: DetailMovieViewController.reusableIdentifier) as? DetailMovieViewController {
            detailMovieVC.movieID = movies.id
            navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movies = listSearchMovies[indexPath.row]
        guard let cellMovie = tableView.dequeueReusableCell(
            withIdentifier: SearchMoviesCell.reusableIdentifier, for: indexPath) as? SearchMoviesCell else {
            return UITableViewCell()
        }
        cellMovie.setupData(with: movies)
        return cellMovie
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.searchTextField.leftView?.tintColor = UIColor.nfRed

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.searchTextField.leftView?.tintColor = UIColor.nfWhite
        searchBar.showsCancelButton = false
        searchBar.text = ""
        presenter.searchMovie(nameMovie: searchBar.text ?? "") {[weak self] _ in
            self?.imgSearchNotFound.image = UIImage(named: "search")
            self?.imgSearchNotFound.isHidden = false
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Invalidate the previous timer to prevent unnecessary search calls
        searchTimer?.invalidate()
        // Create a new timer with a delay of 0.5 seconds
        if searchText.isEmpty {
            imgSearchNotFound.image = UIImage(named: "search")
            hideLoading()
        } else {
            showLoading()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.presenter.searchMovie(nameMovie: searchText) { [weak self] moviesEmpty in
                    if moviesEmpty {
                        self?.imgSearchNotFound.image = UIImage(named: "search_not_found")
                        self?.imgSearchNotFound.isHidden = false
                    } else {
                        self?.imgSearchNotFound.isHidden = true
                    }
                    self?.hideLoading()
                }
            })
        }
    }

    // Handle the "Enter" key press event
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty && listSearchMovies.isEmpty {
                let alert = UIAlertController(title: "No Search Text",
                                              message: "Please enter some text to search for.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        hideLoading()
    }
}

extension SearchViewController: SearchViewProtocol {
    func displaySearchMovies(_ listMovies: [SearchViewEntity]) {
        listSearchMovies = listMovies
        moviesTableView.reloadData()
    }
}
