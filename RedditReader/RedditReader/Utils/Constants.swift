//
//  Constants.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation
import UIKit

struct URLStrings {
    enum topReddits: String {
        case listingTitle = "Top Reddits"
    }
    
    enum cellIdentifiers: String {
        case redditCell = "redditCell"
    }
    
    enum imageAssets: String {
        case placeholder = "placeholder"
    }
}

struct ConstantValues {
    enum sizes: CGFloat {
        case cellHeight = 100.0
        case thumbnailHeight = 70.0
        case fontSize = 16.0
    }
    
    enum margins: CGFloat {
        case leadingTrailing = 15.0
    }
    
    enum HTTPCodes: Int {
        case HTTP_OK = 200
    }
}
