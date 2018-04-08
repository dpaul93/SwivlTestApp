//
//  CommonErrors.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

enum ContentError: Error {
    case noInternetConnection
    case serverError
    case noContentPresent
}
