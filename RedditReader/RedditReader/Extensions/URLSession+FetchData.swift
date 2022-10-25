//
//  URLSession+FetchData.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import Foundation

extension URLSession {
    func fetchData<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {        
        self.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
