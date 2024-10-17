import Foundation
// MARK: - ArtistsViewContractContract

protocol ArtistsViewContract {
    typealias Model = ArtistsViewModelProtocol
    typealias View = ArtistsViewViewProtocol
    typealias Presenter = ArtistsViewPresenterProtocol
}

// MARK: - ArtistsViewViewModelProtocol

protocol ArtistsViewModelProtocol {
    // Define your methods here
}

// MARK: - ArtistsViewViewProtocol

protocol ArtistsViewViewProtocol: AnyObject {
    // Define your methods here
}

// MARK: - ArtistsViewPresenterProtocol

protocol ArtistsViewPresenterProtocol {
    func attach(view: ArtistsViewContract.View)
    func detachView()
    func viewWillAppear()
}
