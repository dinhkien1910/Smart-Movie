//
//  GenresViewViewController.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import UIKit

class GenresViewController: UIViewController {
    // MARK: - Variables
    private var presenter: GenresViewPresenterProtocol = GenresViewPresenter(model: GenresViewModel())
    private var listGenresMovie: [GenresViewEntity] = []
    private var listImage: [String] = [
        "action",
        "adventure",
        "animation",
        "comedy",
        "crime",
        "documentary",
        "drama",
        "family",
        "fantasy",
        "history",
        "horror",
        "music",
        "mystery",
        "romance",
        "science_fiction",
        "tvmovie",
        "thriller",
        "war",
        "western"
    ]

    // MARK: - IBOutlet
    @IBOutlet weak var genresTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        setupMoviesTableView()
        setupUI()
        presenter.fetchListGenreData()
    }

    private func setupMoviesTableView() {
        genresTableView.dataSource = self
        genresTableView.delegate = self
        genresTableView.rowHeight = UITableView.automaticDimension
        genresTableView.registerCell(type: GenreCell.self)
    }

    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                        UIColor(red: 0.90, green: 0.03, blue: 0.08, alpha: 1.0)]
        genresTableView.backgroundColor = .nfBlack
        tabBarController?.tabBar.barTintColor = .black
        navigationController?.navigationBar.barTintColor = .black

    }
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "GenericMovies", bundle: nil)
        if let genericMovieVC = storyboard.instantiateViewController(
            withIdentifier: "GenericMoviesViewController") as? GenericMoviesViewController {
            genericMovieVC.genreID = listGenresMovie[indexPath.row].id
            genericMovieVC.genreTitle = listGenresMovie[indexPath.row].name
            navigationController?.pushViewController(genericMovieVC, animated: true)
        }
    }
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenresMovie.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellGenre = tableView.dequeueReusableCell(
            withIdentifier: GenreCell.reusableIdentifier, for: indexPath) as? GenreCell else {
            return UITableViewCell()
        }
        cellGenre.setupData(with: listGenresMovie[indexPath.row], image: listImage[indexPath.row])
        return cellGenre
    }
}

extension GenresViewController: GenresViewProtocol {
    func displayGenres(_ listGenres: [GenresViewEntity]) {
        listGenresMovie = listGenres
        genresTableView.reloadData()
    }
}
