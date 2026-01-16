//
//  FavoriteRouter.swift
//  game-catalogue-uikit
//
//  Created by Ade Dwi Prayitno on 07/01/26.
//

import UIKit
import Common
import GameDetail
import Core

public protocol FavoriteRouterProtocol: AnyObject {
    func navigateToDetail(from view: UIViewController, game: Game)
}

// @MainActor
// final class FavoriteRouter: FavoriteRouterProtocol {
//
//     func navigateToDetail(from view: UIViewController, game: Game) {
//
//         let presenter = GameDetailPresenter(
//             useCase: Injection().provideGameDetail()
//         )
//
//         let detailVC = GameDetailViewController(
//             presenter: presenter,
//             game: game
//         )
//
//         detailVC.hidesBottomBarWhenPushed = true
//         view.navigationController?.pushViewController(
//             detailVC,
//             animated: true
//         )
//     }
// }
