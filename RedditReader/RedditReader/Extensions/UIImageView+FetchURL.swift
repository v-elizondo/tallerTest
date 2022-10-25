//
//  UIImageView+FetchURL.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import UIKit

extension UIImageView {
    func fetchImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, placeholder: UIImage?) {
        contentMode = mode
        // Load image
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            // Cached image
            DispatchQueue.main.async {
                self.image = image
            }
        } else {
            self.image = placeholder
            // Load from internet
            DispatchQueue.global(qos: .background).async {
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == ConstantValues.HTTPCodes.HTTP_OK.rawValue,
                       let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                       let data = data, error == nil,
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async() { [weak self] in
                            self?.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    
    func fetchImage(from urlString: String, contentMode mode: ContentMode = .scaleAspectFit, placeholder: UIImage?) {
        guard let url = URL(string: urlString) else { return }
        fetchImage(from: url, contentMode: mode, placeholder: placeholder)
    }
}
