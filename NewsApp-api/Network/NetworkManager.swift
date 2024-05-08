//
//  NetworkManager.swift
//  NewsApp-api
//
//  Created by Alex  on 07.05.2024.
//

import Foundation


class NetworkManager {
	
	private let apiKey = "VYUYbhxHjDci4CBacCp1syVUKILNEOSI"
	
	func fetchData(for section: String, completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
		guard let url = URL(string: "https://api.nytimes.com/svc/news/v3/content/nyt/\(section).json?api-key=\(apiKey)") else {
			completion(.failure(NetworkError.invalidURL))
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
				completion(.failure(NetworkError.invalidResponse))
				return
			}
			
			if let data = data {
				do {
					let query = try JSONDecoder().decode(Query.self, from: data)
					completion(.success(query.results))
					print("good1")
				} catch {
					completion(.failure(error))
				}
			}
		}
		
		task.resume()
	}
}

// MARK: - Error Handling

enum NetworkError: Error {
	case invalidURL
	case invalidResponse
}
