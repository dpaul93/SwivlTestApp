//
//  UsersPresenter.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import Result

// MARK: - Output

protocol UsersPresenterOutput: class {
    func handleDataUpdate()
}

// MARK: - Protocol

protocol UsersPresenter: class {
    var output: UsersPresenterOutput? { get set }
    var viewModels: [UsersTableViewCellViewModel] { get }
    
    func handleViewIsReady()
    func loadUsers()
    func loadNextUsers()
    func handleSelectedViewModel(_ viewModel: UsersTableViewCellViewModel)
}

// MARK: - Implementation

private final class UsersPresenterImpl: UsersPresenter, UsersInteractorOutput {
    private let interactor: UsersInteractor
    private let router: UsersRouter
    
    weak var output: UsersPresenterOutput?
    var viewModels = [UsersTableViewCellViewModel]()
    
    init(
        interactor: UsersInteractor,
        router: UsersRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - UsersPresenter
    
    func handleViewIsReady() {
        loadUsers()
    }
    
    func loadUsers() {
        viewModels.removeAll()
        output?.handleDataUpdate()
        interactor.loadUsers { [weak self] result in
            self?.handleUsersResponse(result)
        }
    }
    
    func loadNextUsers() {
        interactor.loadNextUsers { [weak self] result in
            self?.handleUsersResponse(result)
        }
    }
    
    func handleSelectedViewModel(_ viewModel: UsersTableViewCellViewModel) {
        if let link = interactor.getFollowersLink(with: viewModel) {
            router.routeToFollowers(with: link)
        }
    }
    
    // MARK: - Helpers
    
    private func handleUsersResponse(_ response: Result<[UserDTO], ContentError>) {
        switch response {
        case .success(let usersDTO):
            let viewModels: [UsersTableViewCellViewModel] = usersDTO.flatMap { dto in
                guard let profilePicURL = URL(string: dto.profilePicURL) else { return nil }
                
                return UsersTableViewCellViewModelFactory.default(photoURL: profilePicURL, name: dto.name, profileURL: dto.profileURL)
            }
            self.viewModels += viewModels
            output?.handleDataUpdate()
        case .failure: // TODO: Add error handling
            output?.handleDataUpdate()
        }
    }
}

// MARK: - Factory

final class UsersPresenterFactory {
    static func `default`(
        interactor: UsersInteractor = UsersInteractorFactory.default(),
        router: UsersRouter
    ) -> UsersPresenter {
        let presenter = UsersPresenterImpl(
            interactor: interactor,
            router: router
        )
        interactor.output = presenter
        return presenter
    }
}
