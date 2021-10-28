//
//  CustomImageView.swift
//  ImageCaching
//
//  Created by Igor on 28.10.2021.
//

import UIKit

class CustomImageView: UIImageView {
    func fetchImage(from url: String) {
        // в случае битой ссылки возвращаем изображение заглушку
        guard let url = URL(string: url) else {
            image = UIImage(systemName: "person.crop.circle")
            return
        }
        
        // Проверяем, есть ли изображение в кеше и достаем его оттуда
        if let cachedImage = getCachedImage(from: url) {
            // если изображение в кеше есть, то присваиваем его свойству image класса UIImageView
            image = cachedImage
            print("image from cache")
            return
        }
        print("image from net")
        
        // Загружаем изображение из сети и сохраняем в кеш
        NetworkManager.shared.fetchImage(from: url) { data, response in
            self.image = UIImage(data: data)
            
            // Сохраняем в кеш
            self.saveDataToCache(data: data, response: response)
        }
    }
    
    private func saveDataToCache(data: Data, response: URLResponse) {
        // создаем кешируемый объект
        // сохраняем как данные, так и ответ от сервера
        let cachedObject = CachedURLResponse(response: response, data: data)
        
        // передаем URL, который лежит в ответе от сервера
        // по нему будем в будущем искать кешируемый объект
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        
        // Сохраняем в кеш
        URLCache.shared.storeCachedResponse(cachedObject, for: urlRequest)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        // Создаем запрос по URL
        let request = URLRequest(url: url)
        
        // Если в кеше найдены данные по запросу -> Возвращаем их
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        
        return nil
    }
}
