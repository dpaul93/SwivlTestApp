//
//  ApiResponse.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 06.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

enum ApiResultErrors: Error {
    case internerConnectionError
}

enum ApiResponse {
    case success(Data)
    case failure(Error)
    
    var value: Data? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }

    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
