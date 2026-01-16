//
//  FavoritePresenter.swift
//  game-catalogue-uikit
//
//  Created by Ade Dwi Prayitno on 07/01/26.
//

import Combine
import Common
import Core
import UIKit

@MainActor
public protocol FavoriteViewProtocol: AnyObject {
    func onSuccess()
    func onFailed(message: String)
    func onLoading(_ isLoading: Bool)
}

@MainActor
public final class FavoritePresenter {

    var games: [Game] = []

    weak var view: FavoriteViewProtocol?

    private let useCase: FavoriteUseCase
    private let router: FavoriteRouterProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(
        useCase: FavoriteUseCase,
        router: FavoriteRouterProtocol
    ) {
        self.useCase = useCase
        self.router = router
    }

    public func getLocaleGames() {
        view?.onLoading(true)

        useCase.getLocaleGames()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.view?.onLoading(false)
                    if case .failure(let error) = completion {
                        self?.view?.onFailed(
                            message: error.localizedDescription
                        )
                    }
                },
                receiveValue: { [weak self] games in
                    self?.games = games
                    self?.view?.onSuccess()
                }
            )
            .store(in: &cancellables)
    }

    public func didSelectItem(at index: Int, from view: UIViewController) {
        guard index < games.count else { return }
        router.navigateToDetail(
            from: view,
            game: games[index]
        )
    }

}
