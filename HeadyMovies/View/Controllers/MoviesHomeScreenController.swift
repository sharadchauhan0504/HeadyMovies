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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var heightConstraintSearchContainer: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    
    var visibleIndexPaths              = [IndexPath]()
    var currentPageCount               = 1
    var popularMovies: PopularMovies?
    var operatedPopularMovies          = [PopularMoviesResult]()
    var searchedMovies                 = [PopularMoviesResult]()
    let moviesHomeScreenViewModel      = MoviesHomeScreenViewModel()
    var selectedSortFilter: SortFilter = .kNone
    var activityIndicator              = UIActivityIndicatorView(style: .whiteLarge)
    var isSearchOn                     = false
    
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
        
        searchTextField.delegate = self
        
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
        
        hideNextPreviousButton(button: previousButton)
        hideNextPreviousButton(button: nextButton)
    }
    
    private func callPopularMoviesAPI(pageCount: Int) {
        addActivityIndicator()
        moviesHomeScreenViewModel.getMoviesFromServerToParse(pageNumber: pageCount)
        
        moviesHomeScreenViewModel.popularMoviesSuccessCallBack = { [weak self] popularMovies in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                weakSelf.removeActivityIndicator()
                weakSelf.popularMovies = popularMovies
                weakSelf.operateServerData()
                weakSelf.manageNextPreviousButtons()
            }
        }
        
        moviesHomeScreenViewModel.popularMoviesFailureCallBack = { [weak self] in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                weakSelf.removeActivityIndicator()
            }
        }
    }
    
    private func callSearchAPI(searchText: String) {
        let searchString = searchText.replacingOccurrences(of: " ", with: "+")
        addActivityIndicator()
        isSearchOn = true
        moviesHomeScreenViewModel.searchMoviesFromServerToParse(searchString: searchString)
        
        moviesHomeScreenViewModel.searchMoviesSuccessCallBack = { [weak self] popularMovies in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                weakSelf.removeActivityIndicator()
                weakSelf.searchedMovies = popularMovies.results
                weakSelf.movieGridCollectionView.reloadData()
                weakSelf.hideNextPreviousButton(button: weakSelf.previousButton)
                weakSelf.hideNextPreviousButton(button: weakSelf.nextButton)
                weakSelf.searchTextField.resignFirstResponder()
            }
        }
        
        moviesHomeScreenViewModel.searchMoviesFailureCallBack = { [weak self] in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                weakSelf.removeActivityIndicator()
            }
        }
    }
    
    private func operateServerData() {
        guard  let unwrappedPopularMovies = popularMovies else {return}
        switch selectedSortFilter {
        case .kPopularity:
            operatedPopularMovies = moviesHomeScreenViewModel.getMoviesSortedByPopularity(moviesArray: unwrappedPopularMovies.results)
        case .kRating:
            operatedPopularMovies = moviesHomeScreenViewModel.getMoviesSortedByRating(moviesArray: unwrappedPopularMovies.results)
        case .kNone:
            operatedPopularMovies = unwrappedPopularMovies.results
        }
        movieGridCollectionView.reloadData()
    }
    
    private func manageNextPreviousButtons() {
        guard let movieData = popularMovies else {return}
        currentPageCount == movieData.totalPages ? (hideNextPreviousButton(button: nextButton)) : (showNextPreviousButton(button: nextButton))
        currentPageCount <= 1 ? (hideNextPreviousButton(button: previousButton)) : (showNextPreviousButton(button: previousButton))
    }
    
    
    private func scrollToFirstCell() {
        let indexPath = IndexPath(item: 0, section: 0)
        movieGridCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        visibleIndexPaths = [IndexPath]()
    }
    
    private func hideNextPreviousButton(button: UIButton) {
        button.alpha                   = 0.0
        button.removeShadow()
    }
    
    private func showNextPreviousButton(button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            button.alpha                   = 1.0
            button.addBackShadow()
        }) { (success) in
            
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
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
        customPopUpView.selectedSortFilter = selectedSortFilter
        view.addSubview(customPopUpView)
        
        customPopUpView.selectedFilterCallback = { [weak self] selectedFilter in
            guard let weakSelf = self else {return}
            weakSelf.selectedSortFilter = selectedFilter
            weakSelf.operateServerData()
            weakSelf.scrollToFirstCell()
        }
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if sender.tag == 101 {
            sender.tag = 102
            animateSearchHeightConstraint(constant: 50.0)
            searchTextField.becomeFirstResponder()
            searchButton.setImage(UIImage(named: "close"), for: .normal)
        } else {
            sender.tag           = 101
            isSearchOn           = false
            searchTextField.text = ""
            animateSearchHeightConstraint(constant: 0.0)
            searchTextField.resignFirstResponder()
            movieGridCollectionView.reloadData()
            showNextPreviousButton(button: previousButton)
            showNextPreviousButton(button: nextButton)
            searchButton.setImage(UIImage(named: "search"), for: .normal)
        }
    }
    
    private func animateSearchHeightConstraint(constant: CGFloat) {
        heightConstraintSearchContainer.constant = constant
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func navigateToMovieDetails(movieDetails: PopularMoviesResult) {
        let movieDetailScreenController          = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailScreenController") as! MovieDetailScreenController
        movieDetailScreenController.movieDetails = movieDetails
        present(movieDetailScreenController, animated: false, completion: nil)
    }
}

extension MoviesHomeScreenController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideNextPreviousButton(button: previousButton)
        hideNextPreviousButton(button: nextButton)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !isSearchOn {
            showNextPreviousButton(button: previousButton)
            showNextPreviousButton(button: nextButton)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && !isSearchOn  {
            showNextPreviousButton(button: previousButton)
            showNextPreviousButton(button: nextButton)
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
                self.navigateToMovieDetails(movieDetails: ( self.isSearchOn ? (self.searchedMovies[indexPath.item]) : (self.operatedPopularMovies[indexPath.item])  ))
            })
        }
    }
}

extension MoviesHomeScreenController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchOn {
            return searchedMovies.count
        }
        return operatedPopularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell          = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesHomeScreenCollectionCell", for: indexPath) as! MoviesHomeScreenCollectionCell
        if isSearchOn {
            cell.popularMovie = searchedMovies[indexPath.item]
        } else {
            cell.popularMovie = operatedPopularMovies[indexPath.item]
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

extension MoviesHomeScreenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else {return false}
        let trimmedString    = searchText.trimmingCharacters(in: .whitespaces)
        if !trimmedString.isEmpty {
            callSearchAPI(searchText: searchText)
        }
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
}
