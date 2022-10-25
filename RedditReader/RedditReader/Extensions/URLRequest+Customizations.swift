//
//  URLRequest+Customizations.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

extension URLRequest {
    init (_ url: String, parameters:[String: String], method: HTTPMethod = HTTPMethod.get) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        self.init(url: components.url!)
        self.httpMethod = method.rawValue
    }
}
