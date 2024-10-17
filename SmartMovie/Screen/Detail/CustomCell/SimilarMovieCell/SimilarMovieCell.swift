//
//  SimilarMovieCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 07/04/2023.
//

import UIKit

class SimilarMovieCell: UITableViewCell, NibLoadable {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var genresMovie: UILabel!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar5: UIImageView!
    private let detailMovieAPI: GetListDetailMovieAPIProtocol = GetListDetailMovieAPI()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI() {
        imageMovie.clipsToBounds = true
        imageMovie.layer.cornerRadius = 10
        imageMovie.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMinYCorner]
        containView.clipsToBounds = true
        containView.layer.cornerRadius = 10
        footerView.clipsToBounds = true
        footerView.layer.cornerRadius = 10
        footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMaxYCorner]
        footerView.backgroundColor = .nfGray
        nameMovie.textColor = .nfWhite
        genresMovie.textColor = .nfWhite
    }

    func setupData(with data: SimilarMovieViewEntity) {
        genresMovie(movieID: data.id)
        nameMovie.text = data.title
        let arrStar: [UIImageView] = [imgStar1, imgStar2, imgStar3, imgStar4, imgStar5]
        Utilities.instance.drawStar(scoreAverage: data.voteAverage ?? 0, stars: arrStar)
        let placeHolder = UIImage(named: "placeholder")
        if let poster = data.poster {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(poster)") {
                imageMovie.kf.setImage(with: imageUrl, placeholder: placeHolder, options: ImageCache.shared.options)
            }
        } else {
            imageMovie.image = UIImage(named: "placeholder")
        }
    }

    private func genresMovie(movieID: Int) {
        detailMovieAPI.getListDetailMovies(movieID: movieID) {[weak self] result in
            switch result {
            case .success(let listDetailMovieResponse):
            DispatchQueue.main.async {
                var genresArray: [String] = []
                guard let genres = listDetailMovieResponse.genres else {
                    return
                }
                for item in genres {
                    if let name = item.name {
                        genresArray.append(name)
                    }
                }
                let genresText = genresArray.joined(separator: " | ")
                if genresText.isEmpty {
                    self?.genresMovie.text = "No genres"
                } else {
                    self?.genresMovie.text = genresText
                }
                        }
            case .failure(let error):
                print(error)
            }
        }
    }
}
