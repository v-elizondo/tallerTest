//
//  Listing.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

struct Listing: Decodable {
    let kind: String
    let data: ListingData
}

struct ListingData: Decodable {
    let before: String?
    let after: String
    let dist: Int
    let children: [Children]
}

struct Children: Decodable {
    let kind: String
    let data: ChildrenData
}

struct ChildrenData: Decodable {
    let title: String
    let thumbnail: String // Thumbnail of image
    let url: String // Full image
    let author_fullname: String
}
