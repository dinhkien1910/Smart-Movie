//
//  UILabel.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 09/04/2023.
//

import UIKit
extension UILabel {
    func countLines() -> Int {
            let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
            let charSize = font.lineHeight
            let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [NSAttributedString.Key.font: font ?? ""], context: nil)
            let linesRoundedUp = Int(ceil(textSize.height/charSize))
            return linesRoundedUp
        }
}
