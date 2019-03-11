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
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextShadowView: UIView!
    @IBOutlet weak var previousShadowView: UIView!
    
    var visibleIndexPaths = [IndexPath]()
    var currentPageCount = 1
    var popularMovies: PopularMovies?
    let moviesHomeScreenViewModel = MoviesHomeScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        callPopularMoviesAPI(pageCount: currentPageCount)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addGradientWithColor(firstColor: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0), secondColor: UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0))
        
    }
    
    private func initialSetup() {
        let moviesHomeScreenCollectionCell   = UINib(nibName: "MoviesHomeScreenCollectionCell", bundle: nil)
        movieGridCollectionView.register(moviesHomeScreenCollectionCell, forCellWithReuseIdentifier: "MoviesHomeScreenCollectionCell")
        movieGridCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        previousButton.backgroundColor       = UIColor(red:0.04, green:0.13, blue:0.25, alpha:1.0)
        previousButton.layer.cornerRadius    = previousButton.bounds.width * 0.5
        previousButton.layer.masksToBounds   = true
        previousShadowView.addShadowToView(radius: previousButton.bounds.width * 0.5)
        
        nextButton.backgroundColor           = UIColor(red:0.04, green:0.13, blue:0.25, alpha:1.0)
        nextButton.layer.cornerRadius        = nextButton.bounds.width * 0.5
        nextButton.layer.masksToBounds       = true
        nextShadowView.addShadowToView(radius: nextButton.bounds.width * 0.5)
    }
    
    private func callPopularMoviesAPI(pageCount: Int) {
        moviesHomeScreenViewModel.getMoviesFromServerToParse(pageNumber: pageCount)
        
        moviesHomeScreenViewModel.popularMoviesSuccessCallBack = { [weak self] popularMovies in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                weakSelf.popularMovies = popularMovies
                weakSelf.movieGridCollectionView.reloadData()
                weakSelf.showNextPreviousButton()
            }
        }
        
        moviesHomeScreenViewModel.popularMoviesFailureCallBack = { [weak self] in
            guard let _ = self else {return}
        }
        
    }
    
    private func scrollToFirstCell() {
        let indexPath = IndexPath(item: 0, section: 0)
        movieGridCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        visibleIndexPaths = [IndexPath]()
    }
    
    private func hideNextPreviousButton() {
        previousButton.alpha                   = 0.0
        previousShadowView.removeShadow()
        nextButton.alpha                       = 0.0
        nextShadowView.layer.shadowOpacity     = 0.0
    }
    
    private func showNextPreviousButton() {
        UIView.animate(withDuration: 0.25, animations: {
            self.previousButton.alpha                   = 1.0
            self.nextButton.alpha                       = 1.0
            self.previousShadowView.layer.shadowOpacity = 1.0
            self.nextShadowView.layer.shadowOpacity     = 1.0
        }) { (success) in
            
        }
    }
    
    @IBAction func previousButtonAction(_ sender: UIButton) {
        scrollToFirstCell()
        currentPageCount -= 1
        callPopularMoviesAPI(pageCount: currentPageCount)
    }
    
    @IBAction func nextButonAction(_ sender: UIButton) {
        scrollToFirstCell()
        currentPageCount += 1
        callPopularMoviesAPI(pageCount: currentPageCount)
    }
    
    @IBAction func openSortViewButtonAction(_ sender: UIButton) {
        let customPopUpView = CustomFilterPopUpView(frame: view.frame)
        view.addSubview(customPopUpView)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        
    }
    
    private func navigateToMovieDetails(movieDetails: PopularMoviesResult) {
        let movieDetailScreenController          = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailScreenController") as! MovieDetailScreenController
        movieDetailScreenController.movieDetails = movieDetails
        present(movieDetailScreenController, animated: false, completion: nil)
    }
}

extension MoviesHomeScreenController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideNextPreviousButton()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showNextPreviousButton()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            showNextPreviousButton()
        }
    }
}

extension MoviesHomeScreenController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !visibleIndexPaths.contains(indexPath) {
            cell.transform = CGAffineTransform(translationX: 0.0, y: 250)
            visibleIndexPaths.append(indexPath)
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                cell.transform = .identity
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = movieGridCollectionView.cellForItem(at: indexPath) as? MoviesHomeScreenCollectionCell {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: [.curveEaseIn, .allowUserInteraction], animations: {
                cell.transform = .identity
            }, completion: { (success) in
                if let popularMoviesDictionary = self.popularMovies  {
                    self.navigateToMovieDetails(movieDetails: popularMoviesDictionary.results[indexPath.item])
                }
            })
        }
    }
}

extension MoviesHomeScreenController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let popularMoviesDictionary = popularMovies  {
            return popularMoviesDictionary.results.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesHomeScreenCollectionCell", for: indexPath) as! MoviesHomeScreenCollectionCell
        if let popularMoviesDictionary = popularMovies  {
            cell.popularMovie = popularMoviesDictionary.results[indexPath.item]
        }
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
