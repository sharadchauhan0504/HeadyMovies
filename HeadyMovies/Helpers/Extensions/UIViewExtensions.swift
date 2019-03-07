//
//  UIViewExtensions.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 06/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

extension UIView {
    func addGradientWithColor(firstColor: UIColor, secondColor: UIColor) {
        let gradient        = CAGradientLayer()
        gradient.frame      = self.bounds
        gradient.colors     = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
