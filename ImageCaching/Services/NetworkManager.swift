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
    
    func fetchImage(from url: URL, completionHandler: @escaping(Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            // Проверка совпадения адреса запрашиваемой ячейки с адресом вернувшийся картинки
            guard url == response.url else {
                return
            }
            
            // Возврат значения и ответа от сервера
            DispatchQueue.main.async {
                completionHandler(data, response)
            }
        }.resume()
    }
}
