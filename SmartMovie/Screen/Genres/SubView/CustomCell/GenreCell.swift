//
//  GenreCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 03/04/2023.
//

import UIKit

class GenreCell: UITableViewCell, NibLoadable {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var nameGenre: UILabel!
    @IBOutlet weak var imageGenre: UIImageView!
    @IBOutlet weak var footerView: UIView!

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
        footerView.clipsToBounds = true
        footerView.layer.cornerRadius = 10
        footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        footerView.backgroundColor = .nfGray
        imageGenre.layer.cornerRadius = 10
        containView.layer.cornerRadius = 10
        contentView.backgroundColor = .nfBlack
    }

    func setupData(with data: GenresViewEntity, image: String) {
        nameGenre.text = data.name
        imageGenre.image = UIImage(named: image)
    }
}
