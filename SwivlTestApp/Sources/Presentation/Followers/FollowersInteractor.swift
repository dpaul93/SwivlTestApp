//
//  FollowersInteractor.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: - Output

protocol FollowersInteractorOutput: class {}

// MARK: - Protocol

protocol FollowersInteractor: class {
    var output: FollowersInteractorOutput? { get set }
}

// MARK: - Implementation

private final class FollowersInteractorImpl: FollowersInteractor {
    weak var output: FollowersInteractorOutput?
}

// MARK: - Factory

final class FollowersInteractorFactory {
    static func `default`() -> FollowersInteractor {
        return FollowersInteractorImpl()
    }
}
