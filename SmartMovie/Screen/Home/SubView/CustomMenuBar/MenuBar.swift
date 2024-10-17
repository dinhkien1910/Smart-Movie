//
//  MenuBar.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 29/03/2023.
//

import UIKit

enum MenuCategory: Int {
    case movies
    case popular
    case topRated
    case upcoming
    case nowPlaying
    case menuCategoryCount
}

protocol MenuBarDelegate: AnyObject {
    func customMenuBar(scrollTo index: Int)
}
class MenuBar: UIView {
    weak var delegate: MenuBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupCustomTabBar()
        }

        var customTabBarCollectionView: UICollectionView = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                                  collectionViewLayout: collectionViewLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .nfBlack
            return collectionView
        }()

        var indicatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .nfWhite
            return view
        }()
        // MARK: Properties
        var indicatorViewLeadingConstraint: NSLayoutConstraint!
        var indicatorViewWidthConstraint: NSLayoutConstraint!
        // MARK: Setup Views
        func setupCollectioView() {
            customTabBarCollectionView.delegate = self
            customTabBarCollectionView.dataSource = self
            customTabBarCollectionView.showsHorizontalScrollIndicator = false
            customTabBarCollectionView.register(UINib(nibName: MenuViewCell.reusableIdentifier,
                                                      bundle: nil),
                                                forCellWithReuseIdentifier: MenuViewCell.reusableIdentifier)
            customTabBarCollectionView.isScrollEnabled = false

            let indexPath = IndexPath(item: 0, section: 0)
            customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }

        func setupCustomTabBar() {
            setupCollectioView()
            self.addSubview(customTabBarCollectionView)
            customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 55).isActive = true

            self.addSubview(indicatorView)
            indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 4)
            indicatorViewWidthConstraint.isActive = true
            indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
            indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            indicatorViewLeadingConstraint.isActive = true
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }

    }

    // MARK: - UICollectionViewDelegate, DataSource
    extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    MenuViewCell.reusableIdentifier,
                                                                for: indexPath) as? MenuViewCell else {
                return UICollectionViewCell()
            }
            switch MenuCategory(rawValue: indexPath.section) {
            case .movies:
                cell.setupUI(title: "Movies")
                cell.initCell()
                return cell
            case .popular:
                cell.setupUI(title: "Popular")
                return cell
            case .topRated:
                cell.setupUI(title: "Top Rated")
                return cell
            case .upcoming:
                cell.setupUI(title: "Upcoming")
                return cell
            case .nowPlaying:
                cell.setupUI(title: "Now Playing")
                return cell
            default:
                return UICollectionViewCell()
            }
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return MenuCategory.menuCategoryCount.rawValue
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.frame.width / 5, height: 55)
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.customMenuBar(scrollTo: indexPath.section)
        }

        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MenuViewCell else {return}
            cell.menuLabel.textColor = .nfLightGray
        }
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    extension MenuBar: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    }
