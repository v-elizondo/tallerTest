//
//  NetworkConstants.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

struct API {
    static let host = "https://www.reddit.com/"
}

public enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

struct Endpoints {
    enum Listing: String {
        case top = "top.json"
    }
}

struct Parameters {
    enum Listing: String {
        case after = "after"
    }
}
