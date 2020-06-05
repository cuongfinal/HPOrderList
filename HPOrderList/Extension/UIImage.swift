//
//  UIImage.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func lineWithColor(_ color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 15, y: 0, width: size.width-30, height: lineHeight )
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

