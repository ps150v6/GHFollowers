//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users"

    private init() {}

    func getFollowers(
        for username: String, page: Int,
        completion: @escaping ([Follower]?, ErrorMessage?) -> Void
    ) {
        let endpoint =
            "\(baseURL)/\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completion(nil, .invalidUsername)
            return
        }

        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if error != nil {
                completion(nil, .unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completion(nil, .invalidResponse)
                return
            }
            guard let data = data else {
                completion(nil, .invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, .invalidData)
            }
        }

        task.resume()
    }
}
