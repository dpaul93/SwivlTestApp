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
    func handleSelectedViewModel(_ viewModel: UsersTableViewCellViewModel)
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
        viewModels.removeAll()
        output?.handleDataUpdate()
        
        interactor.loadFollowers { [weak self] response in
            switch response {
            case .success(let usersDTO):
                let viewModels: [UsersTableViewCellViewModel] = usersDTO.flatMap { dto in
                    guard let profilePicURL = URL(string: dto.profilePicURL) else { return nil }
                    
                    return UsersTableViewCellViewModelFactory.default(photoURL: profilePicURL, name: dto.name, profileURL: dto.profileURL)
                }
                self?.viewModels = viewModels
                self?.output?.handleDataUpdate()
            case .failure: // TODO: Add error handling
                self?.output?.handleDataUpdate()
            }
        }
    }
    
    func handleSelectedViewModel(_ viewModel: UsersTableViewCellViewModel) {
        if let link = interactor.getFollowersLink(with: viewModel) {
            router.routeToFollowers(with: link)
        }
    }
}

// MARK: - Factory

final class FollowersPresenterFactory {
    static func `default`(
        interactor: FollowersInteractor,
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
