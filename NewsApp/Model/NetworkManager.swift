//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Nodirbek on 17/04/22.
//

import Foundation
import UIKit


enum Errors:String, Error{
    case invalidUrl = "Invalid Url"
    case NoData = "Whoops, there is no data :("
}

class NetworkManager {
    
    let cache = NSCache<NSString, UIImage>()
    let baseUrl = "https:newsapi.org/v2/top-headlines?country=us&category=business&apiKey=35298ec774e8470fb28c0ae706d4382d&page="
    static let shared = NetworkManager()
    
    func getData(page:Int,completion:@escaping (Result<[Article],Errors>)->Void){
        if page > 4 {
            return
        }
        guard let endPoint = URL(string: "\(baseUrl)\(page)") else { return }
        
        let task = URLSession.shared.dataTask(with: endPoint) {data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil else{
                
                completion(.failure(.invalidUrl))
                return
            }
            let decoder = JSONDecoder()
            var dataModel: [Article]
            
            do {
                let result = try decoder.decode(Welcome.self, from: data)
                dataModel = result.articles
                
                completion(.success(dataModel))
            }
            catch{
                
                print(error)
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?)->Void){
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey){
            completion(image)
            return
        }
        guard let url = URL(string: urlString) else { return  }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let image = UIImage(data: data),
                  error == nil else{
                
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
    
}
