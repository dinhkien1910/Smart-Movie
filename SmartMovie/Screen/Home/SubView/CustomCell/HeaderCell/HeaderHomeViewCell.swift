//
//  HeaderHomeViewCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import UIKit

class HeaderHomeViewCell: UICollectionReusableView {

    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var sectionLabel: UILabel!
    private var category: MenuCategory = .movies
    weak var delegate: HomeViewProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    func setupData(section: MenuCategory) {
        sectionLabel.text = Utilities.instance.getStringOfCategory(section: section)
        category = section
    }

    private func setupUI() {
        containView.backgroundColor = .nfBlack
        btnSeeAll.tintColor = .nfLightGray
        sectionLabel.textColor = .nfWhite
    }

    @IBAction func invokeSeeAll(_ sender: Any) {
        delegate?.scrollToSection(scrollTo: category.rawValue)
    }
}
