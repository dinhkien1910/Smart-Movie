//
//  ViewProtocol.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 02/04/2023.
//

import UIKit

protocol NibLoadable {
    static func getNibName() -> String
    static func getNib() -> UINib
}

extension NibLoadable where Self: UIView {
    static func getNibName() -> String {
        return String(describing: self)
    }

    static func getNib() -> UINib {
        let mainBundle = Bundle.main
        return UINib.init(nibName: self.getNibName(), bundle: mainBundle)
    }
}

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
