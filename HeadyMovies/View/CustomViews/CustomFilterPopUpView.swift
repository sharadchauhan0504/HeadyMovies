//
//  CustomFilterPopUpView.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 11/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class CustomFilterPopUpView: UIView {

    @IBOutlet weak var optionsContainerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var highestRatedLabel: UILabel!
    @IBOutlet weak var noneLabel: UILabel!
    
    private var customFilterPopUpView: CustomFilterPopUpView?
    
    var selectedSortFilter: SortFilter? {
        didSet {
            updateSelectedFilter()
        }
    }
    var selectedFilterCallback: ((SortFilter) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initializeSetup()  {
        customFilterPopUpView                   = Bundle.main.loadNibNamed("CustomFilterPopUpView", owner: self, options: nil)?[0] as? CustomFilterPopUpView
        customFilterPopUpView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customFilterPopUpView?.frame            = bounds
        addSubview(customFilterPopUpView!)
        
        optionsContainerView.layer.cornerRadius = 10.0
        optionsContainerView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapGesture(tapGesture:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapGesture(tapGesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    private func setDefaultColorToAllLabels() {
        popularityLabel.textColor   = .darkGray
        highestRatedLabel.textColor = .darkGray
        noneLabel.textColor         = .darkGray
    }
    
    private func updateSelectedFilter() {
        setDefaultColorToAllLabels()
        guard let sortFilter = selectedSortFilter else {return}
        switch sortFilter {
        case .kNone:
            noneLabel.textColor         = .black
            break
        case .kPopularity:
            popularityLabel.textColor         = .black
            break
        case .kRating:
            highestRatedLabel.textColor         = .black
            break
        }
    }
    
    @IBAction func popularityButtonAction(_ sender: UIButton) {
        selectedSortFilter = .kPopularity
        fireCallbackWithSelectedFilter(sortFilter: .kPopularity)
        self.removeFromSuperview()
    }
    
    @IBAction func highestRatedButtonAction(_ sender: UIButton) {
        selectedSortFilter = .kRating
        fireCallbackWithSelectedFilter(sortFilter: .kRating)
        self.removeFromSuperview()
    }
    
    @IBAction func noneButtonAction(_ sender: UIButton) {
        selectedSortFilter = .kNone
        fireCallbackWithSelectedFilter(sortFilter: .kNone)
        self.removeFromSuperview()
    }
    
    private func fireCallbackWithSelectedFilter(sortFilter: SortFilter) {
        if let callBack = selectedFilterCallback {
            callBack(sortFilter)
        }
    }
}
