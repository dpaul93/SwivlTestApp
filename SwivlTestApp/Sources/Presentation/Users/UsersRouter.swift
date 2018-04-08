//
//  UsersRouter.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol UsersRouter {
    
}

// MARK: - Implementation

private final class UsersRouterImpl: NavigationRouter, UsersRouter {
    
}

// MARK: - Factory

final class UsersRouterFactory {
    static func `default`(
        navigationController: UINavigationController
    ) -> UsersRouter {
        return UsersRouterImpl(
            with: navigationController
        )
    }
}
