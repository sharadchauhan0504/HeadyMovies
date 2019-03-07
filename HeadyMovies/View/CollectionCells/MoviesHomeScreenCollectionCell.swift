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
    @IBOutlet weak var movieCoverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    private func initialSetup() {
        contentContainerView.layer.cornerRadius = 5.0
        contentContainerView.layer.masksToBounds = true
    }
}
