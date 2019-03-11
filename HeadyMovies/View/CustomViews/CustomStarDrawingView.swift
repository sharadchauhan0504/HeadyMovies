/*  Star is drawn from top mid to right */

//
//  CustomStarDrawingView.swift
//  StackOverFlow
//
//  Created by Sharad S. Chauhan on 21/08/18.
//  Copyright © 2018 Sharad S. Chauhan. All rights reserved.
//

import UIKit

class CustomStarDrawingView: UIView {

    private let starShapeLayer       = CAShapeLayer()
    private let filledStarShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawStar()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawStar() {

        let path                         = UIBezierPath()
        
        let startPoint                   = CGPoint(x: center.x, y: 0.0)
        path.move(to: startPoint)
        
        let firstLine                    = CGPoint(x: self.bounds.width * 0.65, y: self.bounds.height * 0.35)
        path.addLine(to: firstLine)
        
        let secondLine                   = CGPoint(x: self.bounds.width, y: firstLine.y)
        path.addLine(to: secondLine)
        
        let thirdLine                    = CGPoint(x: secondLine.x - self.bounds.width/4, y: self.bounds.height * 0.6)
        path.addLine(to: thirdLine)
        
        let fourthLine                   = CGPoint(x: self.bounds.width * 0.9, y: self.bounds.height)
        path.addLine(to: fourthLine)
        
        let fifthLine                    = CGPoint(x: center.x, y: fourthLine.y - self.bounds.height/4)
        path.addLine(to: fifthLine)
        
        let sixthLine                    = CGPoint(x: self.bounds.width * 0.1, y: self.bounds.height)
        path.addLine(to: sixthLine)
        
        let seventhLine                  = CGPoint(x: self.bounds.width/4, y: self.bounds.height * 0.6)
        path.addLine(to: seventhLine)
        
        let eighthLine                   = CGPoint(x: 0.0, y: secondLine.y)
        path.addLine(to: eighthLine)
        
        let ninthLine                    = CGPoint(x: self.bounds.width * 0.35, y: self.bounds.height * 0.35)
        path.addLine(to: ninthLine)
        
        path.close()

        starShapeLayer.path              = path.cgPath
        starShapeLayer.fillColor         = UIColor.clear.cgColor
        starShapeLayer.strokeColor       = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0).cgColor
        starShapeLayer.lineWidth         = 1.0

        filledStarShapeLayer.path        = path.cgPath
        filledStarShapeLayer.fillColor   = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0).cgColor


        layer.addSublayer(starShapeLayer)
        layer.addSublayer(filledStarShapeLayer)
    }
    
    private func addMaskToLayerFor(rating: Float) {
        let maskLayer             = CALayer()
        maskLayer.frame           = CGRect(x: 0, y: 0, width: self.bounds.width * CGFloat(rating), height: frame.size.height)
        maskLayer.backgroundColor = UIColor.white.cgColor
        filledStarShapeLayer.mask = maskLayer
    }
    
    func ratingToShowOnStar(rating: Float) {
        addMaskToLayerFor(rating: rating)
    }
    
    func removeAllStarLayers() {
        starShapeLayer.removeFromSuperlayer()
        filledStarShapeLayer.removeFromSuperlayer()
    }
}
