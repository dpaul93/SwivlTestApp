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
    
}

// MARK: - Implementation

private final class FollowersRouterImpl: NavigationRouter, FollowersRouter {
    
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
