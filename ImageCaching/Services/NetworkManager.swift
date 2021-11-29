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
    
    func fetch<T>(stringWithUrl string: String, model: T.Type, completionHandler: @escaping (Result<T, NetworkManagerErrors>) -> Void) where T: Decodable {
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
                let result = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(.success(result))
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
