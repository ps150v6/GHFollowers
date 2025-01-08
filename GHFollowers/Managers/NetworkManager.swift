//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://api.github.com/users"

    private init() {}

    func getFollowers(
        for username: String, page: Int, perPage: Int,
        completion: @escaping (Result<[Follower], GFError>) -> Void
    ) {
        let endpoint =
            "\(baseURL)/\(username)/followers?per_page=\(perPage)&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }

        task.resume()
    }

    func downloadImage(
        from urlString: String, completion: @escaping (UIImage) -> Void
    ) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }

            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }

        task.resume()
    }
}
