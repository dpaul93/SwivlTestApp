//
//  FollowersRouter.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol FollowersRouter {
    func routeToFollowers(with link: String)
}

// MARK: - Implementation

private final class FollowersRouterImpl: NavigationRouter, FollowersRouter {
    func routeToFollowers(with link: String) {
        let router = FollowersRouterFactory.default(navigationController: navigationController)
        let interactor = FollowersInteractorFactory.default(link: link)
        let presenter = FollowersPresenterFactory.default(interactor: interactor, router: router)
        let controller = FollowersViewControllerFactory.new(presenter: presenter)
        navigationController.pushViewController(controller, animated: true)
    }
}

// MARK: - Factory

final class FollowersRouterFactory {
    static func `default`(
        navigationController: UINavigationController
    ) -> FollowersRouter {
        return FollowersRouterImpl(
            with: navigationController
        )
    }
}
