//
//  NetworkManager.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

enum NetworkingError: Error {
    case noInternet
    case badUrl
    case defaultError
    case parseError
}

typealias ResponseHandler = (Result<AnyObject?, Error>) -> Void

class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()
    
    // MARK: - Clients
    let restClient: URLSession
    
    // GCD Queues
    let restQueue = DispatchQueue(label: "REST-Queue",
                                  qos: .userInitiated,
                                  attributes: [.concurrent])
    
    // Initialization
    private init() {
        //Configuration of REST client
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.restClient = URLSession.init(configuration: config)
    }
    
    // MARK: API Methods
    func getTopReddits(after:String = "", completion: @escaping(Result<ListingData, Error>) -> Void){
        let url = API.host+Endpoints.Listing.top.rawValue
        let parameters = [Parameters.Listing.after.rawValue:after]
        let request = URLRequest(url, parameters: parameters, method: .get)
        
        self.restQueue.async {
            self.restClient.fetchData(for: request) { (result:Result<Listing, Error>) in
                switch result {
                case .success(let success):
                    // Callback with reddits array
                    DispatchQueue.main.async {
                        completion(.success(success.data))
                    }
                case .failure(_):
                    // Handle Decode Failure
                    DispatchQueue.main.async {
                        completion(.failure(NetworkingError.parseError))
                    }
                }
            }
        }
    }
}
