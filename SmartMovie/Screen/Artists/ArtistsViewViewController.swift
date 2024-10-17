//
//  ArtistsViewViewController.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 30/03/2023.
//

import UIKit

class ArtistsViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    func setupUI() {
        navigationItem.title = "Artists"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                            UIColor(red: 0.90, green: 0.03, blue: 0.08, alpha: 1.0)]
        view.backgroundColor = .nfBlack
    }
}
