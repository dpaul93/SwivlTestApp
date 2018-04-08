//
//  FollowersPresenter.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import Result

// MARK: - Output

protocol FollowersPresenterOutput: class {
    func handleDataUpdate()
}

// MARK: - Protocol

protocol FollowersPresenter: class {
    var output: FollowersPresenterOutput? { get set }
    var viewModels: [UsersTableViewCellViewModel] { get }

    func handleViewIsReady()
    func refreshFollowers()
}

// MARK: - Implementation

private final class FollowersPresenterImpl: FollowersPresenter, FollowersInteractorOutput {
    
    private let interactor: FollowersInteractor
    private let router: FollowersRouter
    
    weak var output: FollowersPresenterOutput?
    var viewModels = [UsersTableViewCellViewModel]()

    init(
        interactor: FollowersInteractor,
        router: FollowersRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - FollowersPresenter
    
    func handleViewIsReady() {
        refreshFollowers()
    }
    
    func refreshFollowers() {
        
    }
}

// MARK: - Factory

final class FollowersPresenterFactory {
    static func `default`(
        interactor: FollowersInteractor = FollowersInteractorFactory.default(),
        router: FollowersRouter
    ) -> FollowersPresenter {
        let presenter = FollowersPresenterImpl(
            interactor: interactor,
            router: router
        )
        interactor.output = presenter
        return presenter
    }
}
