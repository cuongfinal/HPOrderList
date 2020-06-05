//
//  NSLayoutConstraint.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    private static var _ratioProps = [String:Bool]()
    private static var _increaseHeight = [String:Bool]()
    
    @IBInspectable var ratio:Bool {
        get {
            let tmpRatio = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return NSLayoutConstraint._ratioProps[tmpRatio] ?? false
        }
        set(newValue) {
            let tmpRatio = String(format: "%p", unsafeBitCast(self, to: Int.self))
            NSLayoutConstraint._ratioProps[tmpRatio] = newValue
            if(newValue){
                self.constant = CommonUtil.sizeBasedOnDeviceWidth(size: self.constant)
            }
        }
    }
    
    @IBInspectable var increaseSafeAreaHeight:Bool {
        get {
            let tmpRatio = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return NSLayoutConstraint._increaseHeight[tmpRatio] ?? false
        }
        set(newValue) {
            let tmpRatio = String(format: "%p", unsafeBitCast(self, to: Int.self))
            NSLayoutConstraint._increaseHeight[tmpRatio] = newValue
            if(newValue){
                if #available(iOS 11.0, *) {
                    if let window = UIApplication.shared.keyWindow{
                        let safeAreaInsetsTop = window.safeAreaInsets.bottom
                        self.constant += safeAreaInsetsTop
                    }
                }
            }
        }
    }
}
