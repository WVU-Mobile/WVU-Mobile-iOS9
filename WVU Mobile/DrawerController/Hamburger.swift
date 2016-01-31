//
//  AnimatedButton.swift
//  WVU Mobile
//
//  Created by Richard Deal on 1/28/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//


import Foundation
import QuartzCore
import UIKit

public class Hamburger : UIButton {
    var colors = UIColors()
    
    // Hamburger 
    let top: CAShapeLayer = CAShapeLayer()
    let middle: CAShapeLayer = CAShapeLayer()
    let bottom: CAShapeLayer = CAShapeLayer()
    
    let shortStroke: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 2, 2)
        CGPathAddLineToPoint(path, nil, 30 - 2 * 2, 2)
        return path
        }()
        
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupColors()
    }
    
    func setupColors(){
        self.top.path = shortStroke;
        self.middle.path = shortStroke;
        self.bottom.path = shortStroke;
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = colors.textColor.CGColor
            layer.lineWidth = 2
            layer.miterLimit = 2
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            //let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4)
            
            //layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            
            layer.actions = [
                "opacity": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.top.position = CGPoint(x: 30 - 1, y: 5)
        self.middle.position = CGPoint(x: 15, y: 15)
        
        self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.bottom.position = CGPoint(x: 30 - 1, y: 25)
    }
}