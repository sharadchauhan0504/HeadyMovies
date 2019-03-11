//
//  MoviesHomeScreenCollectionCell.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 06/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class MoviesHomeScreenCollectionCell: UICollectionViewCell {

    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var movieCoverImageView: ImageDownloader!
    
    var popularMovie: PopularMoviesResult? {
        didSet {
            setCellData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieCoverImageView.image = nil
    }
    
    private func initialSetup() {
        contentContainerView.layer.cornerRadius = 5.0
        contentContainerView.layer.masksToBounds = true
    }
    
    private func setCellData() {
        guard let popularMovieData = popularMovie else {return}
        let imageUrlString = "\(IMAGE_BASE_URL)/w200\(popularMovieData.posterPath)"
        if let imageUrl = URL(string: imageUrlString) {
            movieCoverImageView.downloadImageFrom(url: imageUrl, imageMode: .scaleAspectFill)
        }
        
    }
}
