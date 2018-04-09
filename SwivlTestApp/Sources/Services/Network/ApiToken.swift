//
//  ApiToken.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 06.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import Alamofire

enum Method: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .post: return .post
        case .get: return .get
        case .put: return .put
        }
    }
}

enum Encoding {
    case json
    case url
    
    func parameterEncoding() -> ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .url: return URLEncoding.default
        }
    }
}

protocol ApiToken {
    var baseUrl: String { get }
    var parameters: [String: Any] { get }
    var path: String { get }
    var method: Method { get }
    var encoding: Encoding { get }
    var headers: [String: String] { get }
}

enum GitHubApiToken {
    case getUsers(page: Int, perPage: Int)
    case getFollowers(link: String)
}

extension GitHubApiToken: Equatable {
    static func == (lhs: GitHubApiToken, rhs: GitHubApiToken) -> Bool {
        switch (lhs, rhs) {
        case (.getFollowers(let lLink), .getFollowers(let rLink)): return lLink == rLink
        case (.getUsers(let lPage, let lPerPage), .getUsers(let rPage, let rPerPage)): return lPage == rPage && lPerPage == rPerPage
        default: return false
        }
    }
}

extension GitHubApiToken: ApiToken {
    var baseUrl: String {
        switch self {
        case .getFollowers(let link): return link
        default: return "https://api.github.com"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getUsers(let page, let perPage): return ["since": page, "per_page": perPage]
        default: return [:]
        }
    }
    
    var path: String {
        switch self {
        case .getUsers: return "/users"
        default: return ""
        }
    }

    var method: Method {
        switch self {
        case .getUsers, .getFollowers: return .get
        }
    }
    
    var encoding: Encoding {
        switch self {
        default: return .url
        }
    }
    
    var headers: [String : String] {
        switch self {
        default: return [:]
        }
    }
}
