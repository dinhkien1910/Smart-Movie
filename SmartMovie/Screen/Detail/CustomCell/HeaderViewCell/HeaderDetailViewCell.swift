//
//  HeaderDetailViewCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 08/04/2023.
//

import UIKit

class HeaderDetailViewCell: UITableViewHeaderFooterView, NibLoadable {

    @IBOutlet weak var nameSection: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupTitle(with title: String) {
        nameSection.text = title
    }

    private func setupUI() {
        indicatorView.backgroundColor = .nfRed
        nameSection.textColor = .nfWhite
    }
}
