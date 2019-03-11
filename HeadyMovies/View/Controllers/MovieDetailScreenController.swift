//
//  MovieDetailScreenController.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 11/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class MovieDetailScreenController: UIViewController {

    @IBOutlet weak var moviePosterImageView: ImageDownloader!
    @IBOutlet weak var movieDetailContainerView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var starContainerView: UIView!
    @IBOutlet weak var starOneView: UIView!
    @IBOutlet weak var starTwoView: UIView!
    @IBOutlet weak var starThreeView: UIView!
    @IBOutlet weak var starFourView: UIView!
    @IBOutlet weak var starFiveView: UIView!
    
    var movieDetails: PopularMoviesResult?
    var starViewsArray = [UIView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addGradientWithColor(firstColor: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0), secondColor: UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0))
        movieDetailContainerView.addGradientWithColor(firstColor: UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0), secondColor: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0))
    }

    private func initialSetup() {
        guard let movieDetail = movieDetails else {return}
        let imageUrlString = "\(IMAGE_BASE_URL)/w500\(movieDetail.backDropPath)"
        if let imageUrl = URL(string: imageUrlString) {
            moviePosterImageView.downloadImageFrom(url: imageUrl, imageMode: .scaleAspectFill)
        }
        movieTitleLabel.text  = movieDetail.title
        releaseDateLabel.text = movieDetail.releaseDate
        overViewLabel.text    = movieDetail.overview

        movieDetailContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        starViewsArray        = [starOneView, starTwoView, starThreeView, starFourView, starFiveView]

        setRatingStarVlaue(ratingValue: Float(movieDetail.voteAverage/2.0))
    }
    
    private func animateViews() {
        movieDetailContainerView.transform = CGAffineTransform(translationX: 0.0, y: movieDetailContainerView.bounds.height)
        moviePosterImageView.alpha         = 0.0
        
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
            self.movieDetailContainerView.transform = .identity
            self.moviePosterImageView.alpha         = 1.0
        }, completion: nil)
    }
    
    private func setRatingStarVlaue(ratingValue:Float) {
        
        let intValueForRating = Int(ratingValue)
        let decimalFromFloat = (ratingValue).truncatingRemainder(dividingBy: 1)
        
        if decimalFromFloat > 0 {
            let upperBound = intValueForRating + 1
            for i in 0..<starViewsArray.count {
                let starContainerView = starViewsArray[i]
                let customStarView = CustomStarDrawingView(frame: starContainerView.bounds)
                starContainerView.addSubview(customStarView)
                if i < upperBound {
                    if i == upperBound - 1 {
                        customStarView.ratingToShowOnStar(rating: decimalFromFloat)
                    } else {
                        customStarView.ratingToShowOnStar(rating: 1.0)
                    }
                } else {
                    customStarView.ratingToShowOnStar(rating: 0.0)
                }
            }
        } else {
            for i in 0..<starViewsArray.count {
                let starContainerView = starViewsArray[i]
                let customStarView = CustomStarDrawingView(frame: starContainerView.bounds)
                starContainerView.addSubview(customStarView)
                if i < intValueForRating {
                    customStarView.ratingToShowOnStar(rating: 1.0)
                } else {
                    customStarView.ratingToShowOnStar(rating: 0.0)
                }
            }
        }
        
    }
    
    @IBAction func navigateBackButtonAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
