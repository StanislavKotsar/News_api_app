//
//  Webservice.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import Foundation


final class RemoteService {
    
    enum NetworkingError: Error {
        case decodingError
    }
    
    private func configureURL(page: Int) -> URL {
        let url = URL(string: "https://newsapi.org/v2/everything?q=apple&apiKey=590072e9fea246688330859f4b415372&page=\(page)")!
        return url
    }
    
    func loadArticles (page: Int, completion: @escaping (Result<WebModel, NetworkingError>) -> Void) {
        let url = configureURL(page: page)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(WebModel.self, from: data)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}
