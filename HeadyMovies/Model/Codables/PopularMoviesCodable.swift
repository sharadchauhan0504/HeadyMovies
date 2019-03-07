//
//  PopularMoviesCodable.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 07/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation


struct PopularMovies: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [PopularMoviesResult]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct PopularMoviesResult: Codable {
    let voteCount: Int
    let id: Int
    let voteAverage: Double
    let title: String
    let popularity: Double
    let posterPath: String
    let overview: String
    let releaseDate: String
    
    private enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}
