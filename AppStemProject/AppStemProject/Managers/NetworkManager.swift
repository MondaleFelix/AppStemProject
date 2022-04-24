//
//  NetworkManager.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

class NetworkManager {

    // Creates Singleton
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://api.pexels.com/v1/"
    
    func getPhotos(for image: String,completed: @escaping(Result<[Photo], ErrorMessage>) -> Void){
        
        let endpoint = baseURL + "search?query=\(image)"
        
        // Returns if URL is invalid
        guard let url = URL(string: endpoint) else {
            print("err")
            completed(.failure(.invalidUrl))
            return
        }
        
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Returns if error exists
            if let _ = error {
                print("err")

                completed(.failure(.unableToComplete))
                return
            }
            
            // Returns if response is not successful status code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                print("err")

                return
            }
            
            // Returns if data is invalid
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // Trys to decode data, throws failure if invalid
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PhotoList.self, from: data)
                let photos = response.photos

                completed(.success(photos))
                
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
