//
//  MoviesHomeScreenController.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 06/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class MoviesHomeScreenController: UIViewController {

    @IBOutlet weak var movieGridCollectionView: UICollectionView!
    
    let moviesHomeScreenViewModel = MoviesHomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        callPopularMoviesAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addGradientWithColor(firstColor: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0), secondColor: UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0))
    }
    
    private func initialSetup() {
        let moviesHomeScreenCollectionCell = UINib(nibName: "MoviesHomeScreenCollectionCell", bundle: nil)
        movieGridCollectionView.register(moviesHomeScreenCollectionCell, forCellWithReuseIdentifier: "MoviesHomeScreenCollectionCell")
        
        movieGridCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func callPopularMoviesAPI() {
        moviesHomeScreenViewModel.getMoviesFromServerToParse(pageNumber: 1)
    }
}

extension MoviesHomeScreenController: UICollectionViewDelegate {
    
}

extension MoviesHomeScreenController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesHomeScreenCollectionCell", for: indexPath) as! MoviesHomeScreenCollectionCell
        
        return cell
    }
}

extension MoviesHomeScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2 - 30
        let height = collectionView.bounds.height/3
        
        return CGSize(width: width, height: height)
    }
}
