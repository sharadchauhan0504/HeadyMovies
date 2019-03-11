//
//  UIViewExtensions.swift
//  HeadyMovies
//
//  Created by Sharad S. Chauhan on 06/03/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addGradientWithColor(firstColor: UIColor, secondColor: UIColor) {
        let gradient        = CAGradientLayer()
        gradient.frame      = self.bounds
        gradient.colors     = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addShadowToView(radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius  = radius
        layer.shadowPath    = UIBezierPath(rect: bounds).cgPath
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0.0
    }
}
