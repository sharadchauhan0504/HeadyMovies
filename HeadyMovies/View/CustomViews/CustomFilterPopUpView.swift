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
    
    private var customFilterPopUpView: CustomFilterPopUpView?

    
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
    }
}
