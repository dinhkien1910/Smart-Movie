//
//  GenericMoviesViewController.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import UIKit

class GenericMoviesViewController: UIViewController {
    // MARK: - Variables
    private var presenter: GenericMoviesViewPresenterProtocol =
    GenericMoviesViewPresenter(model: GenericMoviesViewModel())
    private var listGenericMovies: [GenericMoviesViewEntity] = []
    var genreTitle: String?
    var genreID: Int?
    // MARK: - IBOutlet
    @IBOutlet weak var genricMoviesTableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        guard let genreID = genreID else {
            return
        }
        setupUI()
        setupGenericMoviesTableView()
        presenter.fetchListGenreData(genreID: genreID)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        genricMoviesTableVIew.reloadData()
    }

   private func setupGenericMoviesTableView() {
        genricMoviesTableVIew.delegate = self
        genricMoviesTableVIew.dataSource = self
        genricMoviesTableVIew.rowHeight = UITableView.automaticDimension
        genricMoviesTableVIew.registerCell(type: GenericMovieViewCell.self)
    }

    private func setupUI() {
        navigationItem.title = genreTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                UIColor(red: 0.90, green: 0.03, blue: 0.08, alpha: 1.0)]
        navigationController?.navigationBar.barTintColor = .black
    }
}

extension GenericMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movies = listGenericMovies[indexPath.row]
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(
            withIdentifier: DetailMovieViewController.reusableIdentifier) as? DetailMovieViewController {
            detailVC.movieID = movies.id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
extension GenericMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenericMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericMovie = listGenericMovies[indexPath.row]
        guard let cellGenericMovie = tableView.dequeueReusableCell(
            withIdentifier: GenericMovieViewCell.reusableIdentifier,
            for: indexPath) as? GenericMovieViewCell else {
            return UITableViewCell()
        }
        cellGenericMovie.setupData(with: genericMovie)
        return cellGenericMovie
        }
    }

extension GenericMoviesViewController: GenericMoviesViewProtocol {
    func displayGenericMovies(_ listMovies: [GenericMoviesViewEntity]) {
        listGenericMovies = listMovies
        genricMoviesTableVIew.reloadData()
    }
}
