//
//  IdentifierReuseCell.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell< T: NibLoadable>(type: T.Type) {
        register(T.getNib(), forCellReuseIdentifier: T.getNibName())
    }

    func registerHeaderFooterCell<T: NibLoadable>(type: T.Type) {
        _ = UINib(nibName: T.getNibName(), bundle: nil)
            register(T.getNib(), forHeaderFooterViewReuseIdentifier: T.getNibName())
        }
}
