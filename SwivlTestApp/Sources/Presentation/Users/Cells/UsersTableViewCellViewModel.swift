//
//  UsersTableViewCellViewModel.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 08.04.18.
//Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol UsersTableViewCellViewModel {
    var photoURL: URL? { get }
    var name: String? { get }
    var profileURL: String? { get }
}

// MARK: Implementation

private class UsersTableViewCellViewModelImpl: UsersTableViewCellViewModel {
    let photoURL: URL?
    let name: String?
    let profileURL: String?

    init(
        photoURL: URL?,
        name: String?,
        profileURL: String?
    ) {
        self.photoURL = photoURL
        self.name = name
        self.profileURL = profileURL
    }
}

// MARK: Factory

class UsersTableViewCellViewModelFactory {
    static func `default`(
        photoURL: URL? = nil,
        name: String? = nil,
        profileURL: String? = nil
    ) -> UsersTableViewCellViewModel {
        return UsersTableViewCellViewModelImpl(
            photoURL: photoURL,
            name: name,
            profileURL: profileURL
        )
    }
}
