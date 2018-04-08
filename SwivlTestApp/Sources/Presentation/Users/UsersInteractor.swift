//
//  UsersInteractor.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import SwiftyJSON
import Result

// MARK: - Output

protocol UsersInteractorOutput: class {}

// MARK: - Protocol

protocol UsersInteractor: class {
    var output: UsersInteractorOutput? { get set }
    var users: [UserDTO] { get }
    
    func loadUsers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ())
    func loadNextUsers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ())
}

// MARK: - Implementation

private final class UsersInteractorImpl: UsersInteractor {
    weak var output: UsersInteractorOutput?
    
    var users = [UserDTO]()
    private let apiService: ApiService
    private let perPage: Int
    private let mapper: AnyGenericArrayMapper<UserDTO>
    
    init(
        apiService: ApiService,
        perPage: Int,
        mapper: AnyGenericArrayMapper<UserDTO>
    ) {
        self.apiService = apiService
        self.perPage = perPage > 0 ? perPage : 1
        self.mapper = mapper
    }
    
    // MARK: - UsersInteractor
    
    func loadUsers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ()) {
        users.removeAll()
        let token = GitHubApiToken.getUsers(page: 0, perPage: perPage)
        loadUsers(with: token, completion)
    }
    
    func loadNextUsers(_ completion: @escaping (Result<[UserDTO], ContentError>) -> ()) {
        guard let page = users.last?.id else {
            completion(.failure(.noContentPresent))
            return
        }
        let token = GitHubApiToken.getUsers(page: page, perPage: perPage)
        loadUsers(with: token, completion)
    }
    
    // MARK: - Helpers
    
    private func loadUsers(with token: ApiToken, _ completion: @escaping (Result<[UserDTO], ContentError>) -> ()) {
        apiService.request(with: token) { [weak self] result in
            switch result {
            case .success(let data):
                let json = JSON(data)
                if let users = self?.mapper.mapArrayFromJSON(json) {
                    self?.users += users
                    completion(.success(users))
                } else {
                    completion(.failure(.noContentPresent))
                }
            case .failure: completion(.failure(.serverError))
            }
        }
    }
}

// MARK: - Factory

final class UsersInteractorFactory {
    static func `default`(
        apiService: ApiService = ApiServiceFactory.default(),
        perPage: Int = 25,
        mapper: AnyGenericArrayMapper<UserDTO> = UserDTOMapperFactory.default()
    ) -> UsersInteractor {
        return UsersInteractorImpl(
            apiService: apiService,
            perPage: perPage,
            mapper: mapper
        )
    }
}
