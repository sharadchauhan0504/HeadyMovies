//
//  MoviesHomeScreenViewModel.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 07/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

class MoviesHomeScreenViewModel {
    
    let networkOperations = NetworkOperations()
    
    func getMoviesFromServerToParse(pageNumber: Int) {
        networkOperations.fetchPopularMovies(pageNumber: pageNumber)
        
        networkOperations.popularMoviesResponseCallback = { [weak self] (responseData, success) in
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(PopularMovies.self, from: responseData)
                print("Result: \(results.results)")
            } catch {
                print(error)
            }
            
        }
    }
}
