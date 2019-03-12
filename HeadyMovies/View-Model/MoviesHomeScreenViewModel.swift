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
    
    var popularMoviesSuccessCallBack: ((PopularMovies) -> Void)?
    var popularMoviesFailureCallBack: (() -> Void)?
    var searchMoviesSuccessCallBack: ((PopularMovies) -> Void)?
    var searchMoviesFailureCallBack: (() -> Void)?
    
    func getMoviesFromServerToParse(pageNumber: Int) {
        networkOperations.fetchPopularMovies(pageNumber: pageNumber)
        
        networkOperations.popularMoviesResponseCallback = { [weak self] (responseData, success) in
            guard let weakSelf = self else {return}
            if success {
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(PopularMovies.self, from: responseData)
                    if let callBack = weakSelf.popularMoviesSuccessCallBack {
                        callBack(results)
                    }
                } catch {
                    print(error)
                }
            } else {
                if let callBack = weakSelf.popularMoviesFailureCallBack {
                    callBack()
                }
            }            
        }
    }
    
    func searchMoviesFromServerToParse(searchString: String) {
        networkOperations.searchMovie(searchString: searchString)
        
        networkOperations.searchMoviesResponseCallback = { [weak self] (responseData, success) in
            guard let weakSelf = self else {return}
            if success {
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(PopularMovies.self, from: responseData)
                    if let callBack = weakSelf.searchMoviesSuccessCallBack {
                        callBack(results)
                    }
                } catch {
                    print(error)
                }
            } else {
                if let callBack = weakSelf.searchMoviesFailureCallBack {
                    callBack()
                }
            }
        }
    }
    
    func getMoviesSortedByPopularity(moviesArray: [PopularMoviesResult]) -> [PopularMoviesResult] {
        return moviesArray.sorted(by: { (p1, p2) -> Bool in
            return p1.popularity > p2.popularity
        })
    }
    
    func getMoviesSortedByRating(moviesArray: [PopularMoviesResult]) -> [PopularMoviesResult] {
        return moviesArray.sorted(by: { (p1, p2) -> Bool in
            return p1.voteAverage > p2.voteAverage
        })
    }
}
