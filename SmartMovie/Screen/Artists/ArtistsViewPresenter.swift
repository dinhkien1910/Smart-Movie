import Foundation

final class ArtistsViewPresenter {
    private weak var contentView: ArtistsViewContract.View?
    private var model: ArtistsViewContract.Model

    init(model: ArtistsViewContract.Model) {
        self.model = model
    }
}

extension ArtistsViewPresenter: ArtistsViewPresenterProtocol {
    func viewWillAppear() {

    }

    func attach(view: ArtistsViewContract.View) {
        contentView = view
    }

    func detachView() {
        contentView = nil
    }
}
