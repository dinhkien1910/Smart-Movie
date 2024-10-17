//
//  ActorCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 07/04/2023.
//

import UIKit
import Kingfisher
class ActorCell: UICollectionViewCell {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var nameActor: UILabel!
    @IBOutlet weak var imageActor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupData(with data: ActorViewEntity) {
        nameActor.text = data.name
        let placeHolder = UIImage(named: "person")
        if let avatar = data.avatar {
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w780/\(avatar)") {
                imageActor.kf.setImage(with: imageUrl, placeholder: placeHolder, options: ImageCache.shared.options)
            }
        } else {
            imageActor.image = UIImage(named: "person")

        }
    }

    func setupUI() {
        imageActor.clipsToBounds = true
        imageActor.layer.cornerRadius = 6
        imageActor.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        containView.clipsToBounds = true
        containView.layer.cornerRadius = 6
        containView.backgroundColor = .nfGray
        nameActor.textColor = .nfWhite
    }
}
