//
//  NetworkOperations.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 06/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

class NetworkOperations {
    
    let urlSession = URLSession(configuration: .default)
    
    var popularMoviesResponseCallback: ((Data, Bool) -> Void)?

    
    func fetchPopularMovies(pageNumber: Int) {
        
        let urlString = "\(BASE_URL)/movie/popular?api_key=\(API_KEY)&page=\(pageNumber)"
        guard let url = URL(string: urlString) else {return}
        
        let dataTask = urlSession.dataTask(with: url) { [weak self] (responseData, response, error) in
            guard let weakSelf = self else {return}
            if error != nil, let callback = weakSelf.popularMoviesResponseCallback {
                callback(Data(), false)
            } else if let data = responseData, let callback = weakSelf.popularMoviesResponseCallback {
                callback(data, true)
            }
        }
        dataTask.resume()
    }
  
}
