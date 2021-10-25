//
//  NetworkManager.swift
//  ImageCaching
//
//  Created by Igor on 25.10.2021.
//

import Foundation

enum NetworkManagerErrors: Error {
    case badUrl
    case dataFetchingError
    case jsonDecodeError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchContacts(stringWithUrl string: String, completionHandler: @escaping (Result<[Contact], NetworkManagerErrors>) -> Void) {
        print("manager is runned")
        guard let url = URL(string: string) else {
            completionHandler(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error descr")
                completionHandler(.failure(.dataFetchingError))
                return
            }

            do {
                let result = try JSONDecoder().decode(Results.self, from: data)
                let contacts = result.results
                
                DispatchQueue.main.async {
                    completionHandler(.success(contacts))
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler(.failure(.jsonDecodeError))
            }
        }.resume()
    }
}
