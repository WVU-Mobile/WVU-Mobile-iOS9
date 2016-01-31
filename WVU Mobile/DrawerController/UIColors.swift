//
//  UIColors.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/4/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.

import UIKit
import Foundation

class UIColors: NSObject {
    var navBarColor: UIColor!
    var mainViewColor: UIColor!
    var menuViewColor: UIColor!
    var selectColor: UIColor!
    var textColor: UIColor!
    var homeBackgroundTint: UIColor!
    var homeCellBackground: UIColor!
    var homeHeaderColor: UIColor!
    var headerColor: UIColor!
    var subtitleTextColor: UIColor!
    var secondaryColor: UIColor!
    var loadingColor: UIColor!
    var tertiaryColor: UIColor!
    var cellColor: UIColor!
    var switchColor: UIColor!
    var housingColor = UIColor(red: 0/255, green: 137/255, blue: 250/255, alpha: 1.0)
    var prtColor = UIColor(red: 108/255, green: 59/255, blue: 255/255, alpha: 1.0)
    var academicColor = UIColor(red: 75/255, green: 150/255, blue: 54/255, alpha: 1.0) // rgb(164, 231, 134)
    var parkingColor = UIColor(red: 62/255, green: 48/255, blue: 140/255, alpha: 1.0) // rgba(82, 237, 199, 1)
    var prtShapeColor = UIColor(red: 128/255, green: 153/255, blue: 255/255, alpha: 1.0) // rgba(82, 237, 199, 1)
    
    //Night mode colors
    private let gold         = UIColor(red: 235/255, green: 211/255, blue: 140/255, alpha: 1.0)
    private let darkGold     = UIColor(red: 150/255, green: 150/255, blue: 140/255, alpha: 1.0)
    private let darkBlue     = UIColor(red: 2/255,   green: 51/255,  blue: 110/255, alpha: 1.0) //#00518d
    private let black        = UIColor(red: 0/255,   green: 21/255,  blue: 40/255,  alpha: 1.0)
    private let clay         = UIColor(red: 0/255,   green: 15/255,  blue: 35/255,  alpha: 1.0)
    private let blue         = UIColor(red: 0/255,   green: 145/255, blue: 234/255, alpha: 1.0)
    private let blueHeader   = UIColor(red: 25/255,  green: 50/255,  blue: 75/255,  alpha: 1.0) //#19324b
    private let alphaGray    = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.4)
    let selectBlue   = UIColor(red: 2/255,   green: 42/255,  blue: 82/255,  alpha: 1.0) //#012a52
    
    //Night -- home screen alpha
    private let homeGray     = UIColor(red: 45/255,  green: 45/255,  blue: 45/255,  alpha: 0.8)
    private let homeBlack    = UIColor(red: 0/255,   green: 21/255,  blue: 40/255,  alpha: 0.9)
    private let homeDarkBlue = UIColor(red: 25/255,  green: 50/255,  blue: 75/255,  alpha: 0.9)
    
    //Day mode colors
    private let lightBlue    = UIColor(red: 172/255,   green: 196/255,  blue: 223/255, alpha: 1.0) //#b1c9e4
    private let lightishBlue = UIColor(red: 147/255,   green: 171/255,  blue: 198/255, alpha: 1.0)
    private let lightYellow  = UIColor(red: 238/255,   green: 219/255,  blue: 174/255, alpha: 1.0) //#eadbae
    private let gray         = UIColor(red: 213/255,   green: 213/255,  blue: 213/255, alpha: 1.0) //#d5d5d5
    private let lightGray    = UIColor(red: 231/255,   green: 231/255,  blue: 231/255, alpha: 1.0) //#e7e7e7
    
    //Day -- home screen alpha
    private let homeBlue    = UIColor(red: 147/255,   green: 171/255,  blue: 198/255, alpha: 0.8)
    private let homeYellow  = UIColor(red: 238/255,   green: 219/255,  blue: 174/255, alpha: 0.85) //#eadbae

  
    //PRT Colors
    let green        = UIColor(red: 179/255, green: 214/255, blue: 148/255, alpha: 1.0) //#b3d694
    let orange       = UIColor(red: 223/255, green: 148/255, blue: 3/255,   alpha: 1.0) //#df9403
    let red          = UIColor(red: 192/255, green: 25/155,  blue: 25/155,  alpha: 1.0)
    let prtGray1     = UIColor(red: 87/255,  green: 87/255,  blue: 87/255,  alpha: 1.0) //#575757
    let prtGray2     = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0) //#cbcbcb
    let prtGray3     = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0) //#cbcbcb
    let pink         = UIColor(red: 255/255, green: 200/255, blue: 200/255, alpha: 1.0) //#fea094
    let alpha        = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.3) //#fea094
    let alpha2       = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.7) //#fea094
    
    //Bus Stop Marker Color
    let mountainLineGreen = UIColor(red: 0/255, green: 158/255, blue: 88/255, alpha: 1.0) //#009e58

    
    override init() {
        super.init()
        self.toggleUIColors()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "nightMode")
    }
    
    func toggleNightMode(){
        NSUserDefaults.standardUserDefaults().setBool(!NSUserDefaults.standardUserDefaults().boolForKey("nightMode"), forKey: "nightMode")
    }
    
    class var sharedInstance: UIColors{
        struct Static {
            static let instance : UIColors = UIColors()
        }
        return Static.instance
    }
    
    func toggleUIColors() {
        switch NSUserDefaults.standardUserDefaults().boolForKey("nightMode") {
        
        case false: // DAY
            navBarColor         = lightBlue
            mainViewColor       = lightYellow
            menuViewColor       = gray
            textColor           = black
            selectColor         = alphaGray
            homeBackgroundTint  = homeGray
            homeCellBackground  = homeYellow
            homeHeaderColor     = homeBlue
            headerColor         = lightishBlue
            subtitleTextColor   = darkGold
            secondaryColor      = gray
            tertiaryColor       = lightishBlue
            loadingColor        = textColor
            cellColor           = UIColor.whiteColor()
            switchColor         = gold
        
        case true: // NIGHT
            navBarColor         = darkBlue
            mainViewColor       = black
            menuViewColor       = clay
            textColor           = gold
            selectColor         = alphaGray
            homeBackgroundTint  = homeBlack
            homeCellBackground  = homeGray
            homeHeaderColor     = homeDarkBlue
            headerColor         = blueHeader
            subtitleTextColor   = darkGold
            secondaryColor      = darkBlue
            tertiaryColor       = selectBlue
            loadingColor        = gray
            cellColor           = blueHeader
            switchColor         = gold
        }
    }
}
