//
//  FollowersInteractor.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import SwiftyJSON
import Result

// MARK: - Output

protocol FollowersInteractorOutput: class {}

// MARK: - Protocol

protocol FollowersInteractor: class {
    var output: FollowersInteractorOutput? { get set }
    var users: [UserDTO] { get }

    func loadFollowers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ())
    func getFollowersLink(with viewModel: UsersTableViewCellViewModel) -> String?
}

// MARK: - Implementation

private final class FollowersInteractorImpl: FollowersInteractor {
    weak var output: FollowersInteractorOutput?
    
    var users = [UserDTO]()
    private let link: String
    private let apiService: ApiService
    private let mapper: AnyGenericArrayMapper<UserDTO>

    init(
        link: String,
        apiService: ApiService,
        mapper: AnyGenericArrayMapper<UserDTO>
    ) {
        self.link = link
        self.apiService = apiService
        self.mapper = mapper
    }
    
    // MARK: - FollowersInteractor
    
    func loadFollowers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ()) {
        users.removeAll()
        let token = GitHubApiToken.getFollowers(link: link)
        apiService.request(with: token) { [weak self] result in
            switch result {
            case .success(let data):
                let json = JSON(data)
                if let users = self?.mapper.mapArrayFromJSON(json) {
                    self?.users = users
                    completion(.success(users))
                } else {
                    completion(.failure(.noContentPresent))
                }
            case .failure: completion(.failure(.serverError))
            }
        }
    }
    
    func getFollowersLink(with viewModel: UsersTableViewCellViewModel) -> String? {
        return users.filter { user in
            user.name == viewModel.name &&
                user.profilePicURL == viewModel.photoURL?.absoluteString &&
                user.profileURL == viewModel.profileURL
            }.first?.followersURL
    }
}

// MARK: - Factory

final class FollowersInteractorFactory {
    static func `default`(
        link: String,
        apiService: ApiService = ApiServiceFactory.default(),
        mapper: AnyGenericArrayMapper<UserDTO> = UserDTOMapperFactory.default()
    ) -> FollowersInteractor {
        return FollowersInteractorImpl(
            link: link,
            apiService: apiService,
            mapper: mapper
        )
    }
}
