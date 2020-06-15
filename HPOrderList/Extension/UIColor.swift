//
//  UIColor.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)  {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    //#e74c3c
    static var mainColor: UIColor {
        return UIColor.init(r: 231, g: 76, b: 60, a: 1)
    }
    
    //#e74c3c
    static var orangeColor: UIColor {
        return UIColor.init(r: 250, g: 177, b: 160, a: 1)
    }
    
    
    static var borderColor = UIColor.init(r: 229, g: 233, b: 238, a: 1)
    
    //#E5E5E5
    static var bgColor: UIColor {
        return UIColor.init(r: 248, g: 249, b: 250, a: 1)
    }
    
    //#1B2031
    static var dark: UIColor {
        return UIColor.init(r: 27, g: 32, b: 49, a: 1)
    }
    
    //#EDEEF1
    static var editBGColor: UIColor {
        return UIColor.init(r: 237, g: 238, b: 241, a: 1)
    }
    
    static var inputBorderColor = UIColor.init(r: 229, g: 233, b: 238, a: 1)
    
    static var whiteThree: UIColor {
        return UIColor.init(r: 252, g: 252, b: 252, a: 1)
    }
    
    //#E6E9EE
    static var veryLightBlue: UIColor {
        return UIColor.init(r: 230, g: 233, b: 238, a: 1)
    }
    
    static var paleBlue: UIColor {
        return UIColor.init(r: 224, g: 228, b: 233, a: 1)
    }
 
    static var blueyGrey: UIColor {
        return UIColor.init(r: 160, g: 165, b: 181, a: 1)
    }
}
