//
//  MenuViewCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    @IBOutlet weak var menuLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            self.menuLabel.textColor = isSelected ? .systemRed : .nfLightGray
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(title: String) {
        menuLabel.text = title
        menuLabel.textAlignment = .center
        menuLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        menuLabel.textColor = .nfLightGray
    }

    func initCell() {
        isSelected = true
    }
}
