//
//  TopRedditsViewModel.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

protocol TopRedditsDelegate: AnyObject {
    func dataModelUpdated()
}

class TopRedditsViewModel {
    // API Access
    private let apiClient = NetworkManager.shared
    
    // Delegate
    weak var delegate: TopRedditsDelegate?
    
    // Data Model
    public var dataModel: [Children] {
        didSet {
            // Notify data has been updated
            delegate?.dataModelUpdated()
        }
    }
    private var latestAfter = ""
    
    init() {
        // Empty init for dataModel
        dataModel = []
    }
    
    // MARK: Public Methods
    func fetchTopReddits() {
        apiClient.getTopReddits { apiResponse in
            if case let .success(response) = apiResponse {
                // Clean the previous data model
                self.dataModel.removeAll()
                // Keep track of the next page
                self.latestAfter = response.after
                // Add the latest API response
                self.dataModel.append(contentsOf: response.children)
            }
        }
    }
    
    func fetchMoreTopReddits() {
        apiClient.getTopReddits(after: latestAfter) { apiResponse in
            if case let .success(response) = apiResponse {
                // Keep track of the next page
                self.latestAfter = response.after
                // Add the latest API response
                self.dataModel.append(contentsOf: response.children)
            }
        }
    }
}
