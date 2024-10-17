//
//  GridViewCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import UIKit
import Kingfisher
class GridViewCell: UICollectionViewCell {
    @IBOutlet weak var imgStar: UIButton!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var timeMovie: UILabel!
    private let detailMovieAPI: GetListDetailMovieAPIProtocol = GetListDetailMovieAPI()
    private var movieID = 0
    private var isStar = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        if isStar {
            DBManager.shared.deleteFavorite(idMovie: movieID)
            imgStar.tintColor = .nfWhite
            isStar = false
        } else {
            DBManager.shared.addStar(idMovie: movieID)
            imgStar.tintColor = .nfRed
            isStar = true
        }
    }

    override func prepareForReuse() {
        movieID = 0
        isStar = false
        imageMovie.image = UIImage()
        nameMovie.text = ""
        timeMovie.text = ""
        imageMovie.kf.cancelDownloadTask()
        imgStar.tintColor = .nfLightGray
    }

    private func setupUI() {
        nameMovie.textColor = .nfWhite
        timeMovie.textColor = .nfLightGray
        imageMovie.layer.cornerRadius = 10
        imageMovie.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMinYCorner]
        containView.backgroundColor = UIColor.nfGray
        containView.clipsToBounds = true
        containView.layer.cornerRadius = 10
    }

    func setupData(with data: HomeViewEntity) {
        movieID = data.id
        nameMovie.text = data.title
        timeMovie(movieID: data.id)
        let placeholder = UIImage(named: "placeholder")
        if let poster = data.poster {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w780/\(poster)") {
            imageMovie.kf.setImage(with: imageUrl, placeholder: placeholder, options: ImageCache.shared.options)
            }
        } else {
            imageMovie.image = UIImage(named: "placeholder")
        }

        if DBManager.shared.getfavorite(idMovie: data.id) == nil {
            imgStar.tintColor = .nfWhite
            isStar = false
        } else {
            imgStar.tintColor = .nfRed
            isStar = true
        }
    }

    private func timeMovie(movieID: Int) {
        detailMovieAPI.getListDetailMovies(movieID: movieID) {[weak self] result in
            switch result {
            case .success(let listDetailMovieResponse):
                if listDetailMovieResponse.runtime == 0 {
                    DispatchQueue.main.async {
                        self?.timeMovie.text = "No duration"
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.timeMovie.text = Utilities.instance.formatRuntime(
                            runtime: listDetailMovieResponse.runtime ?? 0)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
