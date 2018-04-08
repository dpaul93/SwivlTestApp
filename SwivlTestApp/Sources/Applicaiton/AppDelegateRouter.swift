//
//  AppDelegateRouter.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol AppDelegateRouter {
    func routeToUsers()
}

// MARK: Implementation

private final class AppDelegateRouterImpl: AppDelegateRouter {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - AppDelegateRouter
    
    func routeToUsers() {
        guard let navController = window.rootViewController as? UINavigationController else { return }
        let router = UsersRouterFactory.default(navigationController: navController)
        let presenter = UsersPresenterFactory.default(router: router)
        let controller = UsersViewControllerFactory.new(presenter: presenter)
        navController.setViewControllers([controller], animated: false)
    }
}

// MARK: Factory

class AppDelegateRouterFactory {
    static func `default`(window: UIWindow) -> AppDelegateRouter {
        return AppDelegateRouterImpl(window: window)
    }
}
